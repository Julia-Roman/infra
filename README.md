# ❄️ Infra

Supa's multi-system flake

<sub>Screenshot of [dsktp](hosts/nixos/dsktp) as of 11-01-2026</sub>
![](https://github.com/user-attachments/assets/2fc8547a-b10c-4fb6-a187-cc1224f7e6f1)

# 📦 Structure

- 🖼️ [/assets](assets) `shared resources`
- 🧩 [/common](common) `reusable modules`
- 🖥️ [/hosts](hosts) `host-specific setups`
  - ❄️ [/nixos](hosts/nixos) `NixOS systems`
    - 👩🏻‍💻 **[/dsktp](hosts/nixos/dsktp) `desktop`**
      - 🏠 [/home](hosts/nixos/dsktp/home) `app settings`
    - 🌐 **[/homesrv](hosts/nixos/homesrv) `homeserver`**
      - ⚙️ [/etc](hosts/nixos/homesrv/etc) `system overrides`
      - 🛠️ [/services](hosts/nixos/homesrv/services) `service definitions`
