# ❄️ Infra

Supa's multi-system flake

<sub>Screenshot of [Kappa](hosts/nixos/Kappa) as of 11-01-2026</sub>
![](https://github.com/user-attachments/assets/08c57da2-fd82-4713-a117-f726ce1366b6)

# 📦 Structure

- 🖼️ [/assets](assets) `shared resources`
- 🧩 [/common](common) `reusable modules`
- 🖥️ [/hosts](hosts) `host-specific setups`
  - ❄️ [/nixos](hosts/nixos) `NixOS systems`
    - 👩🏻‍💻 **[/Kappa](hosts/nixos/Kappa) `desktop`**
      - 🏠 [/home](hosts/nixos/Kappa/home) `app settings`
    - 🌐 **[/Kappacino](hosts/nixos/Kappacino) `homeserver`**
      - ⚙️ [/etc](hosts/nixos/Kappacino/etc) `system overrides`
      - 🛠️ [/services](hosts/nixos/Kappacino/services) `service definitions`
        - 🔧 [/systemd](hosts/nixos/Kappacino/services/systemd) `standalone services`
        - ...
