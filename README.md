Pinoccio Ruby API
=================

This library gives access to the pinoccio REST API to configure and manage Troops & Scouts. It additionally bundles all the built in ScoutScript commands so that you can command your Scouts straight from Ruby.

Example
-------

    require "pinoccio"

    # Login to the API
    client = Pinoccio::Client.new(USERNAME, PASSWORD) # or alternatively a valid API token
    puts client.account.inspect

    # get a handle to the first Troop (You'll most likely only have one)
    troop = client.troops.first

    # get the lead scout in this troop
    lead_scout = troop.scouts.lead

    # dump out some data about the scout
    puts lead_scout.get('led.report')
    puts lead_scout.power.charging?.inspect
    puts lead_scout.power.percent.inspect
    puts lead_scout.power.voltage.inspect
    puts lead_scout.power.report

    # create a new 'blink' function and print a list off all registered functions
    lead_scout.functions.add(:blink, "if (led.isoff) { led.cyan; } else { led.off; }")
    puts lead_scout.functions.list.inspect

    # run the blink function every 250ms for 3 seconds
    lead_scout.functions.repeat(:blink, 250)
    puts lead_scout.functions.running.inspect
    sleep(3)

    # stop the blink function and ensure the LED is off when we finish
    lead_scout.functions.stop(:blink)
    lead_scout.led.off


Notes
-----
- I've not implemented the full API yet, only really enough to read data so far.
- sometimes the API throws timeout errors, you can rescue and retry these by catching Pinoccio::TimeoutError
- This is just a little playground, no tests yet, use at your own risk.