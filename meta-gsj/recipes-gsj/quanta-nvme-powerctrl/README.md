### NVME SSD Power Control Manager

#### Description
    The Package is mantain for SSD power control and related noification handle Daemon

#### Design
     nvme_gpio.service: initial related GPIOs ( PRESENT, PWR, PWRGD, RST_U2 ) and adjust HW PWR default output signal according to the PRESENT signal. 

     nvme_powermanager.service: loop monitor PRESENT signal and update PWR output.

#### Process

    * Plugging 
        1. U2_[SSD_index]PRSNT_N will be input low
        2. Set PWR_U2_[SSD_index]_EN to high
        3. Check PWRGD_U2_[SSD_index] is high
        4-1. If PWRGD_U2_[SSD_index] is high (PWR Good)
		    - Wait 100ms
            - Set RST_BMC_U2_[SSD_index] high

        4-2. If PWRGD_U2_[SSD_index] is low (PWR Fail)
		    - Set RST_BMC_U2_[SSD_index] low

    * Removing
        1. U2_[SSD_index]PRSNT_N will be input high
        2. PWR_U2_[SSD_index]_EN to low
        3. Check PWRGD_U2_[SSD_index] is low
        4. Set RST_BMC_U2_[SSD_index] low

#### Test

    1. PRESENT detect SSD: The Default Hardware is implement.
    2. Initial SSD slot Power output: nvme_gpio service has tested on Module. It could sucess initial gpios and setting correct power output.
    3. Detect PRESENT and change power setting: nvme_powermanager service has tested on Module. It could success detect SSD plugged or removal change PWR output.
    4. Improve process sequence: The HW PWR default output is high so initiating PWR GPIO don't need set high again. nvme_powermanager.service must wait for nvme_gpio.service complete.
