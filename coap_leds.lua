wifi.setmode(wifi.STATION)
wifi.sta.config("","") 
print("MAC")
print(wifi.sta.getmac())

wlcfg = {
  ip="192.168.0.125",
  netmask="255.255.255.0",
  gateway="192.168.0.1"
}

print("IP")
print(wifi.sta.getip()) 


-- setup CoAP server
cs=coap.Server()
cs:listen(5683)

-- register resources xmas and tree
cs:var(coap.GET, "xmas")
cs:func(coap.PUT, "led_on")
cs:func(coap.PUT, "led_off")
cs:func(coap.GET, "led_status")

cs:func(coap.PUT, "led_start_blink")
cs:func(coap.PUT, "led_stop_blink")

xmas="It's Christmas time!!!"
lighton=0
blinking=0
function led_on()
    lighton=1
    gpio.write(0, gpio.LOW)
end
function led_off()
    lighton=0
    gpio.write(0, gpio.HIGH)
end

tmr.alarm(0,1000,1,function()
        if lighton==0 then 
        lighton=1
        gpio.write(0, gpio.LOW)
    else 
        lighton=0
        gpio.write(0, gpio.HIGH)
    end 
    end)
tmr.stop(0)

function led_start_blink()
    blinking=1
    tmr.start(0)
end

function led_stop_blink()
    blinking=0
    tmr.stop(0)
end

function led_status()
    if blinking == 1 then
        return "blinking"
    end
    if lighton == 1 then
        return "light on"
    end
    return "light off"
    
end

