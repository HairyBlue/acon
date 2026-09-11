#!/usr/bin/env python3
"""
api-runner.py - Direct API fallback execution harness for ACON.

Supports direct invocation of Anthropic Messages API and OpenAI Chat Completions API
using only the Python standard library (urllib.request), avoiding external dependencies.
"""

import argparse
import json
import os
import sys
import urllib.error
import urllib.request


def log_info(msg: str) -> None:
    sys.stderr.write(f"[INFO]  {msg}\n")


def log_error(msg: str) -> None:
    sys.stderr.write(f"[ERROR] {msg}\n")


def determine_provider(model: str, anthropic_key: str, openai_key: str) -> str:
    model_lower = model.lower()
    if any(k in model_lower for k in ["claude", "anthropic"]):
        return "anthropic"
    if any(k in model_lower for k in ["gpt", "o1", "o3", "o4", "chatgpt"]):
        return "openai"
    # Fallback based on available key
    if anthropic_key and not openai_key:
        return "anthropic"
    if openai_key and not anthropic_key:
        return "openai"
    return "anthropic"


def call_anthropic(prompt: str, model: str, api_key: str, dry_run: bool = False, max_tokens: int = 4096) -> str:
    url = "https://api.anthropic.com/v1/messages"
    payload = {
        "model": model,
        "max_tokens": max_tokens,
        "messages": [
            {"role": "user", "content": prompt}
        ]
    }
    headers = {
        "x-api-key": api_key,
        "anthropic-version": "2023-06-01",
        "content-type": "application/json"
    }

    if dry_run:
        log_info(f"Dry run: Simulated Anthropic API call to {url} with model '{model}'")
        return json.dumps({
            "dry_run": True,
            "provider": "anthropic",
            "model": model,
            "prompt_length": len(prompt),
            "status": "simulated_success"
        }, indent=2)

    req = urllib.request.Request(
        url,
        data=json.dumps(payload).encode("utf-8"),
        headers=headers,
        method="POST"
    )

    try:
        with urllib.request.urlopen(req, timeout=120) as resp:
            resp_body = resp.read().decode("utf-8")
            data = json.loads(resp_body)
            content_text = "".join(
                b.get("text", "") for b in data.get("content", []) if b.get("type") == "text"
            )
            return content_text or resp_body
    except urllib.error.HTTPError as e:
        err_body = e.read().decode("utf-8", errors="replace")
        log_error(f"Anthropic API request failed with HTTP {e.code}: {err_body}")
        raise
    except urllib.error.URLError as e:
        log_error(f"Network error connecting to Anthropic API: {e.reason}")
        raise


def call_openai(prompt: str, model: str, api_key: str, dry_run: bool = False, max_tokens: int = 4096) -> str:
    url = "https://api.openai.com/v1/chat/completions"
    payload = {
        "model": model,
        "messages": [
            {"role": "user", "content": prompt}
        ]
    }
    if any(m in model.lower() for m in ["o1", "o3", "o4"]):
        payload["max_completion_tokens"] = max_tokens
    else:
        payload["max_tokens"] = max_tokens

    headers = {
        "Authorization": f"Bearer {api_key}",
        "Content-Type": "application/json"
    }

    if dry_run:
        log_info(f"Dry run: Simulated OpenAI API call to {url} with model '{model}'")
        return json.dumps({
            "dry_run": True,
            "provider": "openai",
            "model": model,
            "prompt_length": len(prompt),
            "status": "simulated_success"
        }, indent=2)

    req = urllib.request.Request(
        url,
        data=json.dumps(payload).encode("utf-8"),
        headers=headers,
        method="POST"
    )

    try:
        with urllib.request.urlopen(req, timeout=120) as resp:
            resp_body = resp.read().decode("utf-8")
            data = json.loads(resp_body)
            choices = data.get("choices", [])
            if choices and "message" in choices[0]:
                return choices[0]["message"].get("content", "")
            return resp_body
    except urllib.error.HTTPError as e:
        err_body = e.read().decode("utf-8", errors="replace")
        log_error(f"OpenAI API request failed with HTTP {e.code}: {err_body}")
        raise
    except urllib.error.URLError as e:
        log_error(f"Network error connecting to OpenAI API: {e.reason}")
        raise


def main() -> int:
    parser = argparse.ArgumentParser(
        description="ACON Direct API fallback runner (Anthropic / OpenAI)"
    )
    parser.add_argument("positional_args", nargs="*", help="Optional [prompt_file] [model]")
    parser.add_argument("-f", "--file", "--prompt-file", dest="prompt_file", help="Path to prompt file")
    parser.add_argument("-t", "--task", dest="task", help="Direct task prompt string")
    parser.add_argument("-m", "--model", dest="model", help="Target model identifier")
    parser.add_argument("-o", "--output", dest="output", help="Optional output file path")
    parser.add_argument("--dry-run", action="store_true", help="Simulate request without network call")
    parser.add_argument("--max-tokens", type=int, default=4096, help="Maximum response tokens")

    args = parser.parse_args()

    prompt_file = args.prompt_file
    model = args.model
    task = args.task

    if args.positional_args:
        if not prompt_file and len(args.positional_args) >= 1:
            if os.path.isfile(args.positional_args[0]):
                prompt_file = args.positional_args[0]
            elif not task:
                task = args.positional_args[0]
        if not model and len(args.positional_args) >= 2:
            model = args.positional_args[1]

    prompt_text = ""
    if prompt_file:
        if not os.path.isfile(prompt_file):
            log_error(f"Prompt file not found: {prompt_file}")
            return 1
        with open(prompt_file, "r", encoding="utf-8") as f:
            prompt_text = f.read()
    elif task:
        prompt_text = task
    else:
        if not sys.stdin.isatty():
            prompt_text = sys.stdin.read()
        else:
            log_error("Must provide either a prompt file (--file), task text (--task), or stdin.")
            return 1

    anthropic_key = os.environ.get("ANTHROPIC_API_KEY", "").strip()
    openai_key = os.environ.get("OPENAI_API_KEY", "").strip()

    if not model:
        log_error("Model identifier must be explicitly provided via --model.")
        return 1

    provider = determine_provider(model, anthropic_key, openai_key)
    log_info(f"Targeting provider: '{provider}' for model: '{model}'")

    if not args.dry_run:
        if provider == "anthropic" and not anthropic_key:
            log_error(f"ANTHROPIC_API_KEY environment variable is missing for Anthropic model '{model}'.")
            return 1
        if provider == "openai" and not openai_key:
            log_error(f"OPENAI_API_KEY environment variable is missing for OpenAI model '{model}'.")
            return 1

    try:
        if provider == "anthropic":
            result = call_anthropic(
                prompt=prompt_text,
                model=model,
                api_key=anthropic_key,
                dry_run=args.dry_run,
                max_tokens=args.max_tokens,
            )
        else:
            result = call_openai(
                prompt=prompt_text,
                model=model,
                api_key=openai_key,
                dry_run=args.dry_run,
                max_tokens=args.max_tokens,
            )
    except Exception as e:
        log_error(f"Execution failed: {e}")
        return 1

    if args.output:
        with open(args.output, "w", encoding="utf-8") as f:
            f.write(result)
        log_info(f"Result written to {args.output}")

    sys.stdout.write(result + ("\n" if not result.endswith("\n") else ""))
    return 0


if __name__ == "__main__":
    sys.exit(main())
