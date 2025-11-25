<?php
/**
 * Reverse Proxy Configuration:
 *
 * Reverse proxy servers are often used to enhance the performance
 * of heavily visited sites and may also provide other site caching,
 * security, or encryption benefits. In an environment where Drupal
 * is behind a reverse proxy, the real IP address of the client should
 * be determined such that the correct client IP address is available
 * to Drupal's logging, statistics, and access management systems. In
 * the most simple scenario, the proxy server will add an
 * X-Forwarded-For header to the request that contains the client IP
 * address. However, HTTP headers are vulnerable to spoofing, where a
 * malicious client could bypass restrictions by setting the
 * X-Forwarded-For header directly. Therefore, Drupal's proxy
 * configuration requires the IP addresses of all remote proxies to be
 * specified in $settings['reverse_proxy_addresses'] to work correctly.
 *
 * Enable this setting to get Drupal to determine the client IP from
 * the X-Forwarded-For header (or $settings['reverse_proxy_header'] if set).
 * If you are unsure about this setting, do not have a reverse proxy,
 * or Drupal operates in a shared hosting environment, this setting
 * should remain commented out.
 *
 * In order for this setting to be used you must specify every possible
 * reverse proxy IP address in $settings['reverse_proxy_addresses'].
 * If a complete list of reverse proxies is not available in your
 * environment (for example, if you use a CDN) you may set the
 * $_SERVER['REMOTE_ADDR'] variable directly in settings.php.
 * Be aware, however, that it is likely that this would allow IP
 * address spoofing unless more advanced precautions are taken.
 *
 * This file is auto-generated from environment variables at container startup.
 * Set the following environment variables to configure:
 *   - REVERSE_PROXY_ENABLED: TRUE or FALSE (default: FALSE)
 *   - REVERSE_PROXY_ADDRESSES: Required if reverse proxy is enabled. Comma-separated IP addresses in quotes (e.g.: '192.168.1.1', '10.0.0.1')
 *   - REVERSE_PROXY_HEADER: Custom header name for client IP (default: empty, uses X-Forwarded-For)
 *   - REVERSE_PROXY_PROTO_HEADER: Custom header name for protocol (default: empty, uses X-Forwarded-Proto)
 *   - REVERSE_PROXY_HOST_HEADER: Custom header name for host (default: empty, uses X-Forwarded-Host)
 *   - REVERSE_PROXY_PORT_HEADER: Custom header name for port (default: empty, uses X-Forwarded-Port)
 *   - REVERSE_PROXY_FORWARDED_HEADER: Custom header name for Forwarded header (default: empty, uses FORWARDED)
 */
$reverse_proxy_enabled = getenv('REVERSE_PROXY_ENABLED');
$settings['reverse_proxy'] = ($reverse_proxy_enabled === 'TRUE' || $reverse_proxy_enabled === 'true' || $reverse_proxy_enabled === '1');

/**
 * Specify every reverse proxy IP address in your environment.
 * This setting is required if $settings['reverse_proxy'] is TRUE.
 */
if ($settings['reverse_proxy']) {
  $reverse_proxy_addresses = getenv('REVERSE_PROXY_ADDRESSES');
  if (empty($reverse_proxy_addresses)) {
    throw new \RuntimeException('REVERSE_PROXY_ADDRESSES is required when reverse_proxy is enabled.');
  }
  // Parse comma-separated IP addresses, handling quotes
  $addresses = array_map('trim', explode(',', $reverse_proxy_addresses));
  $addresses = array_map(function($addr) {
    return trim($addr, " \t\n\r\0\x0B'\"");
  }, $addresses);
  $settings['reverse_proxy_addresses'] = array_filter($addresses);
}

/**
 * Set this value if your proxy server sends the client IP in a header
 * other than X-Forwarded-For.
 */
$reverse_proxy_header = getenv('REVERSE_PROXY_HEADER');
if (!empty($reverse_proxy_header)) {
  $settings['reverse_proxy_header'] = $reverse_proxy_header;
}

/**
 * Set this value if your proxy server sends the client protocol in a header
 * other than X-Forwarded-Proto.
 */
$reverse_proxy_proto_header = getenv('REVERSE_PROXY_PROTO_HEADER');
if (!empty($reverse_proxy_proto_header)) {
  $settings['reverse_proxy_proto_header'] = $reverse_proxy_proto_header;
}

/**
 * Set this value if your proxy server sends the client protocol in a header
 * other than X-Forwarded-Host.
 */
$reverse_proxy_host_header = getenv('REVERSE_PROXY_HOST_HEADER');
if (!empty($reverse_proxy_host_header)) {
  $settings['reverse_proxy_host_header'] = $reverse_proxy_host_header;
}

/**
 * Set this value if your proxy server sends the client protocol in a header
 * other than X-Forwarded-Port.
 */
$reverse_proxy_port_header = getenv('REVERSE_PROXY_PORT_HEADER');
if (!empty($reverse_proxy_port_header)) {
  $settings['reverse_proxy_port_header'] = $reverse_proxy_port_header;
}

/**
 * Set this value if your proxy server sends the client protocol in a header
 * other than Forwarded.
 */
$reverse_proxy_forwarded_header = getenv('REVERSE_PROXY_FORWARDED_HEADER');
if (!empty($reverse_proxy_forwarded_header)) {
  $settings['reverse_proxy_forwarded_header'] = $reverse_proxy_forwarded_header;
}