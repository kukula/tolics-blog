---
title: "ShellSpark: A Spark-like API for Unix Pipelines"
date: 2026-01-20
lastmod: 2026-01-20
draft: false
author: "Tolic Kukul"
description: "ShellSpark compiles Spark-like Python queries into optimised Unix shell pipelines. 235x faster than Hadoop. On your laptop."
tags: ["unix", "python", "performance", "data-engineering"]
categories: ["Software Development"]
---

In 2014, Adam Drake [analysed 2 million chess games](https://adamdrake.com/command-line-tools-can-be-235x-faster-than-your-hadoop-cluster.html) to count player wins. The original approach used a 7-node Hadoop cluster. It processed data at 1.14 MB/sec. **Total time: 26 minutes.**

Adam's approach? `cat | grep | awk | sort`. A shell pipeline. **Total time: 12 seconds.**

That's 270 MB/sec. **235x faster than Hadoop.** On a single machine.

This wasn't a fluke. Shell pipelines stream data through concurrent processes, keeping only what they need in memory. Hadoop loaded everything. The shell version used three integer counters.

A decade later, most developers still reach for distributed frameworks or custom Python scripts. The problem isn't that shell pipelines are obscure. They're just painful.

## The Pain

Should you use `grep -F` or `awk` for filtering? Is `mawk` available? How do you parallelise across files without breaking on spaces in filenames? How do you handle CSV headers in awk?

```
NR==1{for(i=1;i<=NF;i++)h[$i]=i; next}
```

Yeah. That.

Even experienced developers get it wrong. One missing flag and your performance tanks. One wrong escape and your pipeline breaks.

## ShellSpark

I stumbled on Adam's article again yesterday. What if this power was accessible to everyone? Claude helped me see it through in one evening.

ShellSpark compiles declarative Python into optimised shell commands. You write this:

```python
from shellspark import Pipeline

result = (
    Pipeline("sales.csv")
    .parse("csv", header=True)
    .filter(quantity__gt=0)
    .group_by("region")
    .agg(
        total_orders=("*", "count"),
        total_revenue=("price * quantity", "sum")
    )
    .sort("total_revenue", desc=True)
    .run()
)
```

ShellSpark writes this:

```bash
mawk -F, 'NR==1{for(i=1;i<=NF;i++)h[$i]=i; next}
  $h["quantity"]>0{
    key=$h["region"];
    _count[key]++;
    _sum[key]+=$h["price"]*$h["quantity"];
    _keys[key]=1
  }
  END{for(k in _keys){print k","_count[k]","_sum[k]}}' sales.csv \
| sort -t, -k3,3rn
```

It detects whether you have `mawk` (5-10x faster than `gawk`) or `ripgrep` (2-5x faster than grep) and uses them automatically. Compiled commands get cached — subsequent runs are 600-1500x faster because there's nothing to compile.

The API should feel familiar if you've used Spark or Pandas. Filter, select, group, aggregate, sort. Django-style operators like `__gt`, `__contains`, `__regex`. CSV, JSON, and plain text.

## Why It's Fast

Pipes are parallel by default. When you write `cat | grep | awk`, all three processes run concurrently. Data flows through as soon as it's available. The Unix kernel handles it — no framework needed.

Streaming means near-zero memory. That chess analysis processed 3.46GB with three integers. Your data stays in L1/L2 cache where it belongs.

Tools like `mawk` and `ripgrep` are written in C and Rust. Decades of optimisation. Your Python code compiles to the same battle-tested binaries that power production systems worldwide.

No serialisation overhead. Shell pipelines use plain text. No encoding, no decoding, no schema negotiation. Data flows from disk to tool to output.

## Try It

```bash
git clone https://github.com/kukula/shell-spark
cd shell-spark && pip install -e .
```

That's it. Find a CSV on your machine. Any CSV.

```python
from shellspark import Pipeline
print(Pipeline("your_file.csv").parse("csv", header=True).run()[:5])
```

No cluster. No configuration. No waiting.

Your laptop has been a supercomputer this whole time. You just needed the right interface.

---

[GitHub](https://github.com/kukula/shell-spark) — fork it, break it, make it yours.
