import json
from collections import defaultdict
from pathlib import Path

with open("dataset2.json", "r") as f:
    raw = json.load(f)


d = defaultdict(list)
import pdb; pdb.set_trace()
for vs, l in raw:
    d[l].append(vs)

for k, v in d.items():
    data_path = Path(f"dataset_{k.replace('_', '-')}.json")
    final_values = []
    if data_path.exists():
        with open(data_path, "r") as f:
            final_values.extend(json.load(f))
    
    final_values.extend(v)
    with open(data_path, "w") as f:
        json.dump(final_values, f)
