Grover.configure do |config|
  config.options = {
    format: 'A4',
    margin: {
      top: '20px',
      bottom: '20px',
      left: '20px',
      right: '20px'
    },
    prefer_css_page_size: true,
    emulate_media: 'screen',
    bypass_csp: true,
    cache: false,
    timeout: 0, # Timeout in ms. A value of `0` means 'no timeout'
    request_timeout: 10000, # Timeout when fetching the content (overloads the `timeout` option)
    convert_timeout: 20000, # Timeout when converting the content (overloads the `timeout` option, only applies to PDF conversion)
    launch_args: ['--no-sandbox', '--font-render-hinting=medium'],
    omitBackground: true,
    printBackground: true
  }
end
