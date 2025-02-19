import config, network, time

class NetworkConnection:
    def __init__(self):
        print('Initialising WiFi interface...')
        network.country(config.wifi_country)
        network.hostname(config.nickname)
        self._if = network.WLAN(network.STA_IF)
        self._if.active(True)
        self._if.disconnect()
        print('...done.')

    def connect(self):
        if not self._if.isconnected():
            print('Connecting to WiFi network...')
            self._if.connect(config.wifi_ssid, config.wifi_password)
            _timeout = 30
            while not self._if.isconnected():
                if _timeout == 0:
                    self._if.disconnect()
                    print('...timed out.')
                    return False
                _timeout -= 1
                time.sleep(1)
            print('...done.')
        print('Connected to WiFi network with these settings:', self._if.ifconfig())
        return True
    
    def disconnect(self):
        print('Disconnecting from WiFi network...')
        self._if.disconnect()
        print('...done.')
    
net = NetworkConnection()

import asyncio, random
from microdot import Microdot, Request, Response, send_file
from microdot.utemplate import Template
from microdot.websocket import with_websocket

app = Microdot()
Request.max_content_length = 100000
Response.default_content_type = 'text/html'

@app.get('/')
async def index(request):
    return Template('index.html').render()

@app.get('/ws')
@with_websocket
async def read_sensor(request, ws):
    while True:
        await ws.send(str(random.randrange(65536)))
        await asyncio.sleep(0.1)

@app.get('/static/<path:path>')
def static(request, path):
    if '..' in path:
        # directory traversal is not allowed
        return 'Not found', 404
    return send_file('/static/' + path)

@app.get('/update')
async def index(request):
    return Template('update.html').render()

@app.post('/upload')
async def upload(request):
    # obtain the filename and size from request headers
    filename = request.headers['Content-Disposition'].split('filename=')[1].strip('"')
    size = int(request.headers['Content-Length'])

    # sanitize the filename
    filename = filename.replace('/', '_')

    # write the file to the files directory in 1K chunks
    with open('/uploads/' + filename, 'wb') as f:
        while size > 0:
            chunk = await request.stream.read(min(size, 1024))
            f.write(chunk)
            size -= len(chunk)

    print('Successfully saved file: ' + filename)
    return ''

@app.get('/shutdown')
def shutdown(request):
    request.app.shutdown()
    return 'The server is shutting down...'

net.connect()

print('Starting the web server...')
app.run()

net.disconnect()

machine.soft_reset()
