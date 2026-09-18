# Platform Catalog: Multimodal & Creative AI

Reference profiles and parameter syntax for generative image systems, node workflows, 3D asset generation, generative video, and synthetic voice.

---

## 1. Image AI — Scratch Generation

Generative models convert descriptive tokens into visual artifacts. Always distinguish scratch generation from reference editing first.

### Midjourney
- **Syntax Formula:** Comma-separated visual descriptors over prose sentences.
- **Token Order:** `[Subject & Pose]` → `[Setting/Environment]` → `[Art Style & Medium]` → `[Mood & Atmosphere]` → `[Lighting & Color Palette]` → `[Composition & Camera]` → `[Parameters]`.
- **Parameter Flags:** Place technical parameters at the end:
  - Aspect Ratio: `--ar 16:9`, `--ar 1:1`, `--ar 9:16`
  - Version: `--v 6.1` or `--v 7`
  - Style Tuning: `--style raw` (less opinionated, truer to prompt)
  - Stylize: `--s 50` (subtle) to `--s 750` (exaggerated)
- **Negative Prompts:** Append unwanted elements via `--no [element1, element2, text, watermark, blur]`.
- *Reference:* See [Template I](../templates.md#template-i--visual-descriptor).

### DALL-E 3
- **Prose Description:** Responds better to rich descriptive prose paragraphs than comma lists.
- **Layered Spatial Framing:** Explicitly detail foreground, midground, background, and lighting direction.
- **Text Elimination:** DALL-E frequently attempts to render text. Add:
  > *"Do not include any text, letters, signage, or watermarks within the image."*

### Stable Diffusion (SDXL / SD 3.5 / Flux)
- **Weighting Syntax:** Adjust token influence using parentheses: `(concept:1.2)` or `(detail:0.8)`.
- **Negative Prompt (Mandatory for SDXL):** Always include an explicit negative prompt block covering anatomical flaws, artifacts, blur, and distortion.
- **Generation Parameters:**
  - CFG Scale: `7.0–9.0` (SDXL/SD1.5); lower (`3.5–4.5`) for Flux/distilled models.
  - Step Counts: 20–30 for iteration drafts; 40–50 for final production renders.

### SeeDream
- **Artistic & Stylized Generation:** High fidelity for illustrative, anime, cinematic, and painterly concepts.
- **Style Priming:** Specify art style keywords upfront before introducing scene entities. Provide mood and atmosphere tags; supply negative prompt parameters.

---

## 2. Image AI — Reference Editing & Inpainting

Activated when the user requests changes to an existing image or uploads a reference visual.

- **Attach Image First:** Instruct user to attach or upload the base image to the tool prior to pasting the prompt.
- **Delta-Based Prompting:** Describe only what changes and what remains invariant:
  > *"Preserve base subject identity, clothing, and facial features. Modify only the background setting from daytime office to illuminated rainy cyberpunk street."*
- *Reference:* Use [Template J](../templates.md#template-j--reference-image-editing).

---

## 3. ComfyUI (Node-Based Generation)

ComfyUI executes structured pipelines across modular nodes rather than a single unified text field.

- **Pre-Flight Model Check:** Ask which base checkpoint is loaded (e.g., SDXL, Flux.1, Illustrious, Pony) before generating prompts.
- **Dual Block Separation:** Output two distinct, unmerged copy blocks:
  1. `Positive Prompt Block` (weighted tokens, subject, aesthetic triggers, quality tags).
  2. `Negative Prompt Block` (embedding tags, unwanted features, distortion suppressors).
- *Reference:* Use [Template K](../templates.md#template-k--comfyui).

---

## 4. 3D AI — Text-to-3D & Asset Generation

Generates 3D meshes, clean topology, and textured game assets.

- **Descriptor Formula:** `[Style keyword]` + `[Subject]` + `[Key features]` + `[Primary material]` + `[Texture details]` + `[Technical specification]`.
- **Negative Prompts:** Always append: *"no background, no ground plane, no pedestals, no floating detached geometry."*
- **Platform Profiles:**
  - **Meshy:** Best for production game assets, stylized models, and modular props.
  - **Tripo:** Ultra-fast for rapid ideation and clean manifold mesh topology.
  - **Rodin (Deemos):** High-polygon photorealistic capture and digital humans.
- **Technical Export & Rigging:**
  - Specify target format: `GLB/FBX` for engines (Unreal/Unity), `STL` for 3D printing.
  - For characters: explicitly mandate `A-pose` or `T-pose` with symmetrical neutral stance for auto-rigging.

---

## 5. 3D AI — In-Engine Automation (Unity & Blender)

AI copilots integrated directly into digital content creation tools.

- **Unity AI (Unity 6.2+):**
  - Use `/ask` for project and API documentation queries.
  - Use `/run` for automating Editor actions (creating prefabs, placing scene objects).
  - Use `/code` for generating C# scripts matching MonoBehaviour lifecycle.
  - Unity AI Generators: specify asset type (sprite, texture, animation loop) with explicit pixel dimensions and color palettes.
- **BlenderGPT / Blender AI Add-ons:**
  - Generates executable Python scripts using `bpy`.
  - Be explicit about coordinate spaces, mesh names, and operational scope:
    > *"Run script on active selected object only. Do not alter existing modifiers or materials outside the targeted collection."*

---

## 6. Generative Video (Sora, Runway, Kling, LTX, Dream Machine)

Translates narrative concepts into cinematic camera motion, character physics, and temporal scenes.

- **Directorial Framing:** Frame prompts as a film director commanding a cinematographer: camera movement, lens length, lighting, and action pacing.
- **Camera Movement Types:** Explicitly dictate camera trajectory:
  - `Static camera, fixed wide shot`
  - `Slow cinematic dolly forward`
  - `Crane shot descending from canopy to ground level`
  - `Tracking shot keeping pace with subject from profile angle`
- **Platform Strengths:**
  - **OpenAI Sora:** Highly coherent physical simulations and continuous camera travel.
  - **Runway Gen-3 Alpha:** Cinematic lighting, lens flares, and photorealistic grading.
  - **Kling AI:** Superior human motion, facial physics, and complex mechanical choreography.
  - **LTX Video:** High-speed generations; keep prompts concise, visual, and motion-focused.
  - **Luma Dream Machine:** Expressive dynamic motion, dramatic angles, and volumetric atmosphere.

---

## 7. Synthetic Voice & Audio (ElevenLabs)

Voice synthesis engines converting text and delivery markers into spoken audio.

- **Parameter Control:** Prose descriptions do not translate directly to vocal nuances. Provide explicit acoustic tags:
  - `[Tone/Emotion]`: Authoritative, empathetic, contemplative, urgent, whisper.
  - `[Pacing/Speed]`: Deliberate, measured, rapid, natural conversational cadence.
  - `[Accents/Age]`: Neutral mid-Atlantic, Scottish brogue, mature, youthful.
- **SSML & Delivery Markers:** Use phonetic guides, punctuation pauses, and emphasis brackets:
  > *"Emphasize [keyword] with a slight pause before delivery: `<break time='400ms'/>`."*
