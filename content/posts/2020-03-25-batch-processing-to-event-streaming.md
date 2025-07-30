---
title: "From Batch Processing to Event Streaming: A Paradigm Shift"
date: 2020-03-25
author: "Tolic Kukul"
tags: ["event-streaming", "batch-processing", "software-architecture", "real-time-systems", "data-processing", "strangler-fig"]
series: ["Software Architecture"]
description: "A real-world story of migrating from brittle batch processing to event-driven architecture using the strangler fig pattern. Learn practical migration strategies."
---

At Jora, we used to rely heavily on a big legacy batch-processing pipeline — and I mean **really** batch. Think nightly jobs, full-day downtimes for tiny DB migrations, and that sinking feeling when one bad record caused the whole thing to silently fail halfway through.

It was manageable… until it wasn’t.

## The Breaking Point

One day, I found myself staring at yet another migration ticket. It was a minor schema tweak — something that should take 5 minutes. But because of how brittle the pipeline was, it meant we’d have to **pause the entire timeline**, rerun upstream dependencies, and monitor for hours just to make sure nothing broke.

That’s when I asked my manager:  
> “What if we stopped batching and started streaming?”

To my surprise, he said:  
> *“If you believe in it — go for it.”*

That was the green light. But it came with a catch:  
I had to figure out the architecture, prototype it, calculate the cost, and convince the team — basically carry the whole transition from start to finish.

## Prototyping the Future

So I rolled up my sleeves and got to work. I spent a couple of months diving deep into tooling and trade-offs. I explored different messaging systems, cloud services, cost models, and failure patterns.

In the end, I landed on this combo:

- **EventBridge** for event routing  
- **Lambda** functions for lightweight, isolated processing  
- **DynamoDB** for fast, flexible storage  
- **EC2-backed services** for parts that needed more control  
- And **our existing Luigi pipeline**, which we kept running alongside for a while

But here’s the key: I didn’t tear down the old system overnight. Instead, I used the **Strangler Fig Pattern** — we added new components around the old ones, mirrored events, and gradually phased legacy jobs out one by one.

No big bang. No panic deployments. Just slow, deliberate progress.

## Real-World Wins

Once we had the core pieces in place, everything started to click.

- Schema changes? Now zero downtime.  
- Pipeline visibility? We could trace individual events across the system.  
- Cost control? I literally estimated infra costs down to the dollar.  
- Performance? Realtime instead of waiting for the nightly run.  
- Developer happiness? Through the roof — no one missed debugging 3-hour-long jobs.

It felt like flipping on the lights in a room we had been stumbling around in for years.

## Getting Everyone On Board

Of course, tech is just half the story. I had to bring the team along.

I shared the PoC, mapped out the business impact, walked product and SEO folks through how this would help during acquisitions. (One of those projects included building a complex redirect system for SEO when merging job boards.)

Everyone was skeptical at first — until they saw that it worked.

## Lessons Learned

Looking back, this was one of those projects that reshaped how I think about systems — not just the code, but **the people, the trust, and the safety nets you need to change direction**.

I learned that big shifts don’t need big drama.  
You can strangle a legacy system with care, not chaos.  
And sometimes, all it takes to spark a new architecture is asking the right question:

> “What if we stopped batching, and started streaming?”
