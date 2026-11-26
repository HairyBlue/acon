# Reference Case 1: E-Commerce Customer Support SOP & Miro Decision-Tree

> **Domain:** Multi-market DTC e-commerce support (Shopify + fulfillment agent + masked tracking)  
> **Pattern:** Always-Apply Rules -> Context Check -> Miro Decision-Tree Routing -> Dual-Sheet Logging

This reference documents a production-grade e-commerce Customer Support SOP modeled after a visual Miro decision board. It combines **global non-negotiable rules**, **9 deterministic ticket branches**, **localized templates**, and **mandatory dual-sheet logging** (`Issue Sheet` + `Refunds & Returns`).

---

## 1. Global Rules (Apply in Every Branch)

| Rule | Standard |
| :--- | :--- |
| **Tracking** | Only ever send the internal/masked `LC` tracking number and store tracking link. Never send the carrier's raw tracking number, never mention origin country (e.g., China), and never send a supplier document to a customer. |
| **Language** | Always reply in the exact language the customer is writing in, regardless of which market or inbox the email came from. Never default to English. |
| **The Product** | Never promise unverified specs (hours, degrees, etc.). If unsure whether a claim is true, ask the team lead; never invent it. |
| **Speed** | First reply within 24 hours, every market, every day. Any ticket older than 48 hours must be escalated to the team lead the same day. |
| **Money** | No refund of any kind while the parcel is still on its way. If the customer says the product is faulty, reship a new product for free. Full refund only after the return has arrived and been inspected. |
| **Logging** | Every case goes in the `Issue Sheet`. Returns and refunds go in `Refunds & Returns` as well. A perfect email with nothing logged is an unfinished job. |
| **When Solved** | If the customer is happy, ask for a Trustpilot review mentioning your name. |

---

## 2. Master Ticket Triage (Entry -> 9 Branches)

```mermaid
flowchart TD
    A["New Email Received"] --> B["Check any earlier customer conversations for context"]
    B --> C1["1. Return Request"]
    B --> C2["2. Delivery Status"]
    B --> C3["3. Cancel Order Request"]
    B --> C4["4. General Question"]
    B --> C5["5. Not got their package in timeframe?"]
    B --> C6["6. Missing item(s)?"]
    B --> C7["7. Payment method / discount / checkout issue"]
    B --> C8["8. Customs or extra fee/costs"]
    B --> C9["9. Receipt or invoice"]
```

---

## 3. Return Request & Faulty Product Tree (Miro Top Branches)

```mermaid
flowchart TD
    R0["Return Request"] --> F0["Does the customer say the product is FAULTY?"]
    R0 --> D0{"Parcel delivered?"}

    %% Faulty Product Branch
    F0 --> F1["Ask what is faulty + video or photo evidence of the fault"]
    F1 --> F2["Cracked stick, spout, or anything clearly broken/damaged"]
    F1 --> F3["Broken Box?"]
    F1 --> F4["Does not cool good"]
    F1 --> F5["Overflows when you insert it"]
    F1 --> F6["It pours slow"]
    F1 --> F7["Does not fit bottle / leaking around the top"]

    F2 --> F2A["Explain rare issue, apologize, ask for photo for records, ship replacement immediately once photo arrives + log reshipment in Issue Sheet"]
    F3 --> F3A["Ask for photo, apologize, say it should never happen, ship new one for free + log in Issue Sheet"]
    F4 --> F4A["Send cooling guide: freeze overnight before use, insert into pre-chilled bottle (keeps cold much longer than room-temp bottle)"]
    F5 --> F5A["Send usage guide: take a small sip or pour first glass before inserting chiller so bottle does not overflow"]
    F6 --> F6A["Explain slower pour is intentional: spout controls flow so drink gets air contact (aeration) to improve taste and aroma"]
    F7 --> F7A["Ask for photo + short video + drink/bottle type + bottle neck diameter (if possible) to check product vs. unusual bottle size"]

    %% Parcel Not Delivered Branch
    D0 -- "No" --> D1{"Does the customer have more than 1 order with us?"}
    D1 -- "No" --> D1N["No refund and no 30% yet (not full, not partial). Give LC tracking # + tracking link (verify 17TRACK matches & no errors), ask them to contact again once delivered for return instructions"]
    D1 -- "Yes" --> D1Y["Explain customer pays return cost, so instead offer a 30% refund + keep the product"]

    %% Parcel Delivered Branch
    D0 -- "Yes" --> K0{"Return Reason Known?"}
    K0 -- "No" --> K0N["Ask for return reason"]
    K0 -- "Yes" --> K1{"Wrong Size / Color?"}

    K1 -- "Yes" --> K1A["Offer a free resend, customer can keep the first product"]
    K1A --> K1B{"Declined?"}
    K1B -- "Yes" --> K1C["Explain customer pays return cost, so instead offer a 30% refund + keep the product"]

    K1 -- "No" --> K2{"Damaged / Faulty Product?"}
    K2 -- "Yes" --> K2A["Ask for picture and proof of the product"]
    K2A --> K2B{"Received picture?"}
    K2B -- "Yes" --> K2C["Offer a free resend, customer can keep the first product"]
    K2C --> K2D{"Declined?"}
    K2D -- "Yes" --> K2E["Offer a 30% Refund"]

    K2 -- "No" --> K3{"No Special Reason?"}
    K3 -- "Yes" --> K3A["Send normal (EU) or outside-EU return instructions depending on customer market"]
```

---

## 4. Delivery Status & Cancel Order Request (Miro Middle Branches)

```mermaid
flowchart TD
    %% Delivery Status
    DS0["Delivery Status"] --> DS1["Send LC tracking # + our tracking link, then check corresponding tracking # on 17TRACK before replying"]
    DS1 --> DS2{"Does 17TRACK match our tracking page?"}
    DS2 -- "No" --> DS2N["Report tracking mismatch ASAP (Order #, LC tracking #, 17TRACK #, screenshots of both) + inform customer we will investigate & flag email"]
    DS2 -- "Yes" --> DS3{"Is there any tracking issue or unusual status? (exception, failed attempt, wrong address, returning, held, customs, stalled, carrier error, wrong ETA)"}
    DS3 -- "Yes" --> DS3Y["Report issue ASAP before taking further action (Order #, tracking #s, status, screenshot) + inform customer & flag email"]
    DS3 -- "No" --> DS3N["Everything looks normal -> Reply with LC tracking # & our tracking link"]

    %% Cancel Order Request
    CO0["Cancel Order Request"] --> CO1{"Order marked as fulfilled in Shopify?"}
    CO1 -- "No" --> CO2{"Does customer have more than 1 order with us?"}
    CO2 -- "No" --> CO2N["Follow SOP regarding avoiding order cancellations"]
    CO2 -- "Yes" --> CO2Y["Submit Cancellation Request: add 'request to cancel order' in Issue Sheet -> tell customer we are checking if shipped -> wait for agent decision"]
    CO2Y --> CO2D{"Agent Decision"}
    CO2D -- "Declined" --> CO2D1["Inform customer order has already shipped and cannot be canceled"]
    CO2D -- "Approved" --> CO2D2["Request refund (log Refunds & Returns) -> inform customer cancellation succeeded and refund is processing"]

    CO1 -- "Yes" --> CO3{"Does customer have more than 1 order with us?"}
    CO3 -- "No" --> CO3N["Explain it is too late; they need to return the order once received"]
    CO3N --> CO3U{"Customer upset?"}
    CO3U -- "Yes" --> CO3U1["Explain politely it is too late, must return once received, and we cannot do anything further"]
    CO3 -- "Yes" --> CO3Y["Offer a 30% refund on the item they wished to cancel (keep it) & explain they can also return the order when received for a full refund"]
```

---

## 5. General, Missing Package (POD), Missing Items, Payment, Customs & Invoice (Miro Lower Branches)

```mermaid
flowchart TD
    %% General Question
    G0["General Question"] --> G1["Give a comforting, fitting, personalized answer removing any doubts"]

    %% Not got package in timeframe
    NP0["Not got their package in timeframe?"] --> NP1["Check if tracking number shows delivered or not"]
    NP1 --> NP2["Not delivered"]
    NP1 --> NP3["Delivered"]
    NP2 --> NP2A["Fill out Issue Sheet + let customer know we are investigating + reassure"]
    NP3 --> NP3A["ASK FOR POD (Proof of Delivery) in Issue Sheet + ask customer to confirm address"]
    NP3A --> NP4{"Address check"}
    NP4 -- "Wrong address" --> NP4W["Explain not delivered due to wrong address -> put correct address in Issue Sheet -> ask for reship + new tracking #"]
    NP4 -- "Correct address" --> NP4C["Put in Issue Sheet to reship ASAP with new tracking # -> tell customer carrier marked delivered, out of kindness we will ship another package"]

    %% Missing items
    MI0["Missing item(s)?"] --> MI1{"Do we know what is missing?"}
    MI1 -- "Yes" --> MI1Y["Reship missing item(s) ASAP + apologize warmly and kindly"]
    MI1 -- "No" --> MI1N["Ask customer to confirm all items received + photo evidence + compare vs. Shopify order"]
    MI1N --> MI2{"Confirmed missing?"}
    MI2 -- "Yes" --> MI1Y
    MI2 -- "No" --> MI2N["Explain order contains everything ordered and clear up misunderstanding"]

    %% Payment / Customs / Invoice
    PM0["Payment method / discount / checkout issue"] --> PM1["Escalate to team lead ASAP with order # + issue"]
    CU0["Customs or extra fee/costs"] --> CU1["Explain there are no custom/extra fees; everything is included in the price paid on website"]
    RI0["Receipt or invoice"] --> RI1["Order confirmation is the Receipt; for company/VAT invoices, explain company orders must be placed via email (cannot enter VAT/Org # at checkout)"]
```

---

## 6. Dual-Sheet Logging & SOP Checklist

1. **Issue Sheet (Operations / Fulfillment):** Log **every** case with its own distinct row and order number (`#XXXX`), tracking numbers, issue type, and required action:
   - Late order
   - Lost order
   - Wrong address
   - Delivery error
   - Refund approval needed
   - Return request
   - Product damaged
   - Missing item
   *(Write the problem in the sheet, tell the fulfillment agent what you need, and request any needed info such as POD.)*
2. **Refunds & Returns Sheet (Finance):** Log **every** return instruction sent, partial 30% refund, or full refund (never duplicate another order's row). A return request touches **both** sheets (`Issue Sheet` for the case, `Refunds & Returns` for the money).

---

## 7. Detailed Operational SOPs (Notion Reference)

### 7.1 Shipping Schedule, Order Status & Cancellations
- **Shipping Window:** Monday to Friday, `04:00-12:00 CET` (no weekend shipments).
- **Order Status:**
  - `Yellow` = Unfulfilled (not shipped yet).
  - `Grey` = Fulfilled / Distributed by Agent (considered **shipped**, even if tracking has not updated yet; can **never** be canceled).
- **Weekday Cancellation Delay Rule:** If a cancellation request arrives within 24 hours of the shipping window, **do not reply immediately**; wait until the order ships and turns `Grey`, then reply that it has already shipped.
- **Weekend Exception:** If the request arrives Friday evening or Saturday (`Yellow`), cancel it and log it in the `Issue Sheet` (if Sunday, hold/ignore as on weekdays). If `Grey`, reply immediately that it has already shipped.

### 7.2 Carrier & Delivery Windows (Verify on 17TRACK + Send Store Link Only)
- **Internal Check:** Always verify the corresponding tracking number on `https://www.17track.net/en` before replying.
- **Customer-Facing Tracking:** Only ever send the masked `LC-XXXX-XXXXX` number and the localized store tracking page (never send carrier links or raw carrier tracking numbers):

| Market | Typical Delivery Window (Work Days) | Store Tracking Path Pattern |
| :--- | :--- | :--- |
| **SE** (Sweden) | 5-12 work days | `/pages/spara-din-order` |
| **DK** (Denmark) | 8-10 work days | `/pages/spor-din-ordre` |
| **NO** (Norway) | 7-15 work days | `/pages/spor-din-ordre` |
| **NL / BE** | 5-10 work days | `/pages/volg-je-bestelling` |
| **FI** (Finland) | 5-12 work days | Store tracking page |
| **World / UK / US / CA** | Market standard | `/pages/track-your-order` |

### 7.3 The 4 Core Exception Playbooks
1. **Missing Item:** Open the order lines to verify what was ordered. **Always reship the missing part** (never refund instead). In the same email, ask for a photo of what they *did* receive (evidence for `Issue Sheet`), log under `Missing item`, and instruct fulfillment to send the missing part. Never question the customer.
2. **Damaged / Faulty Product:** If the fault is already described, do not ask them to describe it again. Require a **photo/video** first, and state in the same email: *once the photo arrives, we will ship a free replacement and you can keep the broken one*. Log under `Product damaged`. Never reship before receiving the photo; never refund instead of reshipping.
3. **30% Keep-It Offer:** Offer 30% back while keeping the item when the customer no longer wants it and the order is already shipped (`Grey`) or delivered. If declined, move to normal returns. **Never** offer it twice in the same thread; never refund 100% or cancel a `Grey` order.
4. **Delivered Not Received (POD):** Request Proof of Delivery (POD) **internally** in the `Issue Sheet` (never ask the customer for POD). In the same email, ask the customer to confirm their full delivery address so we can compare it against the order (do not promise a reship yet).
   - Wrong address -> explain address mismatch, log correct address in `Issue Sheet`, request reship + new tracking number.
   - Correct address -> log reship ASAP in `Issue Sheet` with new tracking number, explain carrier marked delivered and we are sending a replacement as a goodwill gesture.

### 7.4 Customer-Caused Reshipment Fee
Use when a package is returned/undeliverable due to customer error (missed pickup deadline, wrong/incomplete address):
1. Explain the delivery failed due to the address/pickup issue, and offer a **reduced reshipment fee** (~$8-$14) instead of placing a full-price new order.
2. Send the market-specific reshipment payment link and ask for the **new order number** once paid.
3. Verify payment + updated delivery address on the new order.
4. Instruct the shipping agent to **reship the original order** (using the original order number, not the fee order).

### 7.5 Return Sent but Never Arrived at Warehouse
1. Check where the carrier actually delivered it; state plainly if it was delivered somewhere other than the warehouse.
2. **No refund until the return arrives at the warehouse and is inspected** (never bend this rule, even if the customer threatens escalation).
3. Ask the customer for the shipping receipt / proof that they sent it to the correct return address, and instruct them to contact the carrier to trace it.
4. Log in **both** `Issue Sheet` and `Refunds & Returns`.

---

## 8. Sample Response Templates (Adapt & Translate to Customer's Language)

> **Important:** Always translate into the customer's exact language, keep tone calm and helpful, and replace `[placeholders]` with verified order facts.

### A. Delivery Status (Normal Tracking)
```text
Subject: Update on your order #[OrderNumber]

Hi [Name],

Thanks for reaching out! Your order is currently on its way.

You can track your parcel using your tracking code [LC-XXXX-XXXXX] on our tracking page here:
[Localized Store Tracking Link]

Let us know if you have any other questions!

Best regards,
[Brand Name]
```

### B. Cancellation Refusal (Order Already Shipped / Grey)
```text
Subject: Your cancellation request - Order #[OrderNumber]

Hi [Name],

Thank you for contacting us.

We are unable to cancel order #[OrderNumber] because it has already been shipped out. Once the parcel arrives, please reach out to us if you would still like to arrange a return.

Best regards,
[Brand Name]
```

### C. Damaged / Faulty Product (Photo Required Before Free Reship)
```text
Subject: Your order #[OrderNumber]

Hi [Name],

I am really sorry to hear that your item arrived damaged, and sorry for the inconvenience!

Could you please reply with a quick photo (or short video) showing the damage? We need this for our records, and as soon as we receive the photo, we will ship a brand-new replacement to you free of charge (you do not need to return the damaged one).

Best regards,
[Brand Name]
```

### D. Missing Item (Photo Evidence + Free Reship)
```text
Subject: Missing item in order #[OrderNumber]

Hi [Name],

I am so sorry that an item was missing from your package!

We will ship the missing item to you right away at no cost. Could you also send a quick photo of what you received in the parcel so we can attach it to our warehouse report?

Best regards,
[Brand Name]
```

### E. 30% Keep-It Offer (Shipped or Delivered Order)
```text
Subject: Your return request - Order #[OrderNumber]

Hi [Name],

Thank you for reaching out.

Because return shipping is covered by the customer, we can offer an easier option: we can issue a 30% refund right away and you can keep the product, so you do not have to pay for or arrange a return.

Would you like us to go ahead with the 30% refund, or would you prefer the return instructions instead?

Best regards,
[Brand Name]
```

### F. Delivered Not Received (POD + Address Confirmation)
```text
Subject: Delivery check - Order #[OrderNumber]

Hi [Name],

Thank you for letting us know. We are looking into this with our shipping partner right away.

To help us compare against your order details, could you please confirm your full delivery address (street, postal code, and city)? Once we hear back from you and our carrier, we will update you on the next step.

Best regards,
[Brand Name]
```

### G. EU Return Instructions
```text
Subject: Your return request - Order #[OrderNumber]

Hi [Name],

Thank you for reaching out. Here are the return instructions for order #[OrderNumber]:

Return Address:
[Warehouse Name / Receiver]
[Street Address]
[Postal Code & City, Country]
Phone: [Warehouse Phone]

Please make sure to:
- Ship with a tracking number (return shipping is covered by the customer).
- Include your order number (#[OrderNumber]) and full name on a note inside the package or written clearly on the outside.
- Refunds are processed within 5-10 business days after the return arrives at our warehouse and is inspected.

Feel free to reply with your return tracking number once shipped!

Best regards,
[Brand Name]
```

### H. Outside-EU Return Instructions (UK / US / CA)
```text
Subject: Your return request - Order #[OrderNumber]

Hi [Name],

Thank you for reaching out.

Since your return will be shipped from outside the EU to our warehouse in [Country], it must be declared correctly as "Returned goods - no commercial value" on the customs declaration. Incorrectly declared packages may be stopped in customs or returned to you.

Return address:
[Warehouse Name / Receiver]
[Street Address]
[Postal Code & City, Country]
Phone: [Warehouse Phone]

Please note:
- The return shipping cost is covered by the customer.
- Any customs or import fees related to the return are the responsibility of the customer.
- Mark the customs declaration as "Returned goods - no commercial value".
- Packages arriving with unpaid customs charges will be refused and no refund can be issued.
- If the package is stopped in customs and returned to you, no refund can be issued.
- The refund is processed only after the return has arrived at our address and been inspected (within 5-10 business days after arrival).

If you have any questions before shipping, we are happy to assist.

Kind regards,
[Brand Name]
```

### I. Customer-Caused Reshipment Fee
```text
Subject: Reshipment for order #[OrderNumber]

Hi [Name],

Your parcel for order #[OrderNumber] could not be delivered due to [missed pickup / incomplete address] and was returned.

Instead of placing a completely new order at full price, we can reship your original order if you cover the reduced reshipping fee here:
[Market-Specific Reshipment Payment Link]

Once you complete the payment, please reply with your new order number and confirm your full delivery address so we can arrange the reshipment right away.

Best regards,
[Brand Name]
```

### J. Return Sent but Never Arrived at Warehouse
```text
Subject: Update on your return - Order #[OrderNumber]

Hi [Name],

Thank you for following up.

We checked the tracking for your return, and it shows the parcel was delivered to [Location Shown by Carrier] rather than our warehouse address. Because we can only issue a refund once the return arrives at our warehouse and is inspected, we are unable to process the refund yet.

Could you please send us your shipping receipt showing the destination address you sent it to, and contact the carrier directly so they can trace where the parcel was delivered?

Best regards,
[Brand Name]
```

### K. Review + Bonus Ask (When Solved & Customer Is Happy)
*(Skip for markets without a live Trustpilot page, such as NL if not yet set up.)*
```text
I am happy we got this sorted!

If you are satisfied, a short Trustpilot review mentioning my name "[Your Name]" would really help me a lot, it only takes a minute. Thanks so much!
[Localized Trustpilot Link]
```
