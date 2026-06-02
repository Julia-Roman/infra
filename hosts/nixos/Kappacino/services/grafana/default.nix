{
  ...
}:
{
  services.grafana = {
    enable = true;
    settings = {
      security.secret_key = "$__file{/etc/secrets/grafana/secret_key}";
      server = {
        http_addr = "0.0.0.0";
        http_port = 3133;
        domain = "metrics.supa.codes";
        root_url = "https://metrics.supa.codes/";
        serve_from_sub_path = true;
      };
      "auth.anonymous" = {
        enabled = true;
        org_name = "supa.codes";
        org_role = "Viewer";
      };
    };
  };
}
