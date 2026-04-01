# Task 7: Разграничение и аудит безопасности подов

## Структура
- `01-create-namespace.yaml` — создаёт `audit-zone` с включённым PSA.
- `insecure-manifests/` — поды-нарушители.
- `secure-manifests/` — исправленные поды, соответствующие профилю Restricted и правилам Gatekeeper.
- `gatekeeper/` — шаблоны (Rego) и сами ограничения Constraint.
- `verify/` — bash-скрипты для быстрой проверки применения политик.
