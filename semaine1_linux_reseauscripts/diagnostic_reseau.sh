#!/bin/bash
echo "=== Diagnostic réseau $(hostname) ==="
date
ip a
echo "--- Routes ---"
ip route
echo "--- Connexions TCP (top 10) ---"
ss -tunap | head -n 20
echo "--- Test ping google ---"
ping -c 3 8.8.8.8 || true
echo "--- Résolution DNS ---"
dig +short github.com || host github.com || true
