@echo off
title "CodeMaster Startup Server & Tunnel"
echo ===========================================
echo Starting CodeMaster Local Server on port 5555...
cd /d "c:\Users\Ali\code_master"
start "CodeMaster Server" /min "C:\Users\Ali\Downloads\flutter\bin\dart.exe" bin/server.dart

echo Starting Cloudflare Tunnel for port 5555...
start "Cloudflare Tunnel" /min "C:\Program Files (x86)\cloudflared\cloudflared.exe" tunnel --config C:\Users\Ali\.cloudflared\config.yml run
echo ===========================================
echo Both local server and internet tunnel are launching in the background (minimized)!
timeout /t 5
