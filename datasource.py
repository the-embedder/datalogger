import machine #, time, asyncio
from threadsafe import ThreadSafeQueue

class AnaloguePulseCounter:
    def __init__(self, pin):
        self.queue = ThreadSafeQueue(10)
        self._tim = machine.Timer()
        self._adc = machine.ADC(machine.Pin(pin))

    # timer-based soft-IRQ handler
    def _handler(self, _):
        try:
            self.queue.put_sync(self._adc.read_u16())
        except IndexError:
            pass

    def start(self):
        self._tim.init(callback=self._handler, freq=10)

    def stop(self):
        self._tim.deinit()
