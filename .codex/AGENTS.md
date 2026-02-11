# Global Configuration

## GCP VMs
| VM | GPU | Notes |
|----|-----|-------|
| **nick-dev** | 1x T4 16GB | Lightweight dev/testing |
| **nick-a100-80** | 1x A100 80GB SXM4 | Primary dev VM (a2-ultragpu-1g, us-central1-a) |

- **Data disk**: 300GB mounted at /data (nick-a100-80)
- **Python**: 3.10 installed; prefer 3.12 for new work, venvs in ~/venvs/

## Airgapped Cluster (SCREAM Lab)

### GPU Nodes
| Node | GPUs | Available GPUs | Notes |
|------|------|----------------|-------|
| **rebellion.scream.lab** | 8x A100-80GB | All 8 (0-7) | Full access |
| **westvleteren.scream.lab** | 8x H200-140GB | GPUs 4-7 only | `CUDA_VISIBLE_DEVICES=4,5,6,7` |
| **utopias.scream.lab** | 16x V100-32GB | All 16 (0-15) | Smaller VRAM, good for parallel small jobs |

### Access Machines
| Machine | Role | Notes |
|---------|------|-------|
| **becks.scream.lab** | On-base Linux box | Physical access, plug in drive to copy data directly to cluster |
| **tommyknocker.scream.lab** | KVM virtual machine | Remote access via DREN laptop + VPN, read-only mirror to cluster |

### Cluster Details
- **Shared filesystem**: `/fs6/active/nkashani` (visible from all nodes)
- **HuggingFace mirror (models)**: `/models/hf/` — local mirror of HF model repos, structured like HF (e.g., `/models/hf/Qwen/Qwen2.5-7B-Instruct`)
- **HuggingFace mirror (datasets)**: `/data/hf/` — local mirror of HF dataset repos (e.g., `/data/hf/openai/gsm8k`)
- **Usage**: Treat paths like HF repo IDs. E.g., `load_dataset("/data/hf/openai/gsm8k", ...)` or `AutoModelForCausalLM.from_pretrained("/models/hf/Qwen/Qwen2.5-7B-Instruct")` — works as a drop-in replacement for online HF access.
- **Python**: 3.12. Create venvs on node, `pip install` uses internal mirror
- **Job runner**: tmux/screen (no SLURM), sessions persist indefinitely
- **No walltime limit**: Jobs run unattended for days

### Cluster Constraints
- **NO INTERNET**: Airgapped military network. No PyPI, HuggingFace, or external access.
- **Pip mirror only**: Internal mirror for pip installs. If a package isn't mirrored, it's unavailable.
- **GPU restriction on westvleteren**: Only GPUs 4,5,6,7. Always set `CUDA_VISIBLE_DEVICES=4,5,6,7`.
- **No remote write-back**: Cannot write results back to external drives remotely.

### Data Transfer Workflow
1. **Prepare everything on dev VM** (nick-a100-80) — code, data, configs, pip freeze
2. **Transfer to cluster** via:
   - **On-base**: Plug physical drive into **becks.scream.lab** (Linux box on military base), copy directly to `/fs6/active/nkashani`
   - **Remote (slow)**: DREN laptop + VPN into **tommyknocker.scream.lab** (KVM), copy files through read-only mirror volume to cluster
3. **Run experiments** via tmux (persistent sessions, survive disconnect)
4. **Collect results physically** — go in person (typically Monday), copy from `/fs6/active/nkashani` to portable drive, transfer back to dev VM
