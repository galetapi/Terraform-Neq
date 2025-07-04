import requests
from requests.auth import HTTPBasicAuth
import time

# === CONFIGURA ESTOS VALORES ===
opensearch_url = "https://vpc-es-pdn-co-6-0-s3gehnpnazjvk6oxqryt2oq3xq.us-east-1.es.amazonaws.com"
username = "MasterOS"
password = "0p3nSctM4ster*"
auth = HTTPBasicAuth(username, password)
headers = { "Content-Type": "application/json" }

# ✅ Lista específica de índices que deseas verificar y mover a 'cold' si están en 'warm'
all_indices = [
    "nequilogs-wlp-messages-ism-001140",
    "nequilogs-wlp-messages-ism-001127",
    "nequilogs-wlp-messages-ism-001150",
    "nequilogs-wlp-messages-ism-001167"
]

# === 1. Consultar ISM state por lotes usando /_plugins/_ism/explain ===
print("🔍 Verificando estado de los índices...\n")
warm_indices = []

# OpenSearch permite hasta ~100 índices por lote. Aquí son pocos.
explain_response = requests.post(
    f"{opensearch_url}/_plugins/_ism/explain",
    json={"index": all_indices},
    auth=auth,
    headers=headers
)

if explain_response.status_code != 200:
    print(f"❌ Error al consultar /_explain: {explain_response.text}")
    exit()

explained = explain_response.json()

# === 2. Imprimir el estado de todos los índices y filtrar los que están en warm ===
print("📋 Estado actual de índices:\n")

for index_name in all_indices:
    data = explained.get(index_name)
    if not data:
        print(f"⚠️  {index_name}: No gestionado por ISM o sin datos.")
        continue

    state = data.get("state", {}).get("name", "SIN ESTADO")
    print(f"🔸 {index_name}: estado actual = {state}")

    if state == "warm":
        warm_indices.append(index_name)

# === 3. Mover índices warm a cold ===
print("\n🚀 Intentando mover a 'cold'...\n")

for index in warm_indices:
    url = f"{opensearch_url}/_plugins/_ism/change_policy/{index}"
    payload = { "state": "cold" }

    response = requests.post(url, json=payload, auth=auth, headers=headers)

    if response.status_code == 200:
        print(f"✅ {index} movido a 'cold'")
    else:
        print(f"❌ ERROR en {index}: {response.status_code} - {response.text}")

    time.sleep(0.5)  # Pausa corta por si hay throttling

# === 4. Resumen final
print("\n✅ Proceso completado.")
print(f"Total índices en warm: {len(warm_indices)}")
