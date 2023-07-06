---
layout: page
title:  "Creating High-Speed Electrical Analysis for Energy Research"
teaser: "An archive of a paper I wrote based on a project I did for NREL between 2010 and 2014 for high speed, real time power analysis"
date:   2023-07-01 22:55:01 -0700
categories: electrical power
tags: electrical hardware power energy DAQ FPGA real-time LabVIEW NI
published: true
header: no
image:
    title: NREL_ESIF.jpg
    caption: NREL ESIF
    caption_url: https://nrel.gov
---
_The text that follows is a slightly reworded (taking out the marketing perspective and verbiage) version of a paper I initially wrote back in 2014 for the company I was working for at the time. This paper was originally published in [Digital Engineering 24/7](https://www.digitalengineering247.com/)._

During 2010, the contract engineering company I was working for at the time was invited to propose a solution to the National Renewable Energy Laboratory (NREL) for distributed power monitoring within the newly designed Energy Systems Integration Facility (ESIF).

NREL scientists and engineers research renewable energy and energy-efficient technologies, often partnering with private industry to deliver these ideas to the general public. NREL designed the ESIF to facilitate groundbreaking research in areas such as solar and wind, power grid planning and operations, energy storage, building technologies, fuel cells, and advanced vehicles. Each lab at the 182,500 square foot facility is designed and instrumented to foster research on all aspects of energy systems integration. Some of the unique capabilities of these labs include the ability to perform hardware-in-the-loop (HIL) simulations at megawatt-scale power, petascale computing at the High-Performance Computing Data Center, and the unique Research Electrical Distribution Bus (REDB). Monitored with CompactRIO (an embedded real time data acquisition platform and controller), REDB is the ultimate power integration circuit. It consists of two AC and two DC ring buses that interconnect multiple sources of energy across the facility, enabling NREL to work with industry to provide plug-and-play testing at real-world grid-scale levels.

Since the ESIF is intended for researching various forms of energy integration, NREL researchers needed a system for monitoring power usage and controlling safety systems for each experiment or laboratory on a facility-wide scale. Monitoring AC and DC power loads can provide researchers with power usage information for their individual experiments and allow facility managers to view the total energy usage on a facility-wide or laboratory-by-laboratory basis. An additional benefit is the safety monitoring for laboratories in the event of dangerous electrical conditions caused by experiments, ultimately protecting the researchers and facility equipment.

![REDB](/assets/images/posts/NREL_REDB.jpg)
>The REDB is the electrical backbone interconnecting many of the laboratories at ESIF. This state-of-the-art facility will enable NREL and industry to work together to develop and evaluate their individual technologies.
_Image: [NREL](https://nrel.gov)_

Researchers needed a power monitor they could configure on an individual experiment basis for multiphase AC and DC measurements. They also needed a power meter they could use to configure the meter to mimic multiple types of circuit breakers while analyzing power characteristics such as real power, reactive power and energy. To enable live analysis of complex energy experiments, researchers required high-speed and high-resolution data (16-bit, 50/100KS/s+). Furthermore, the power monitor needed to communicate to various third-party human machine interfaces (HMIs) and programmable logic controller (PLC) devices from Wonderware and Siemens. A power monitor capable of providing all of these features did not exist in the market. As a result, my company was hired as a subcontractor to NREL to develop such a device for the ESIF.

### Solution Details

I provided software images for more than 70 (72 I believe) CompactRIO units installed within electrical panels throughout the ESIF. The solution is responsible for monitoring electrical conditioning components between the ESIF's power sources (120V, 240V, 480V, and 600V AC plus 500V and 1,000V DC on 250A and 1,600A busses, with 2,500A in the future) and the laboratory power connections. As a result, any powered device under test or equipment used for testing in the lab was actively monitored by CompactRIO, both from a power consumption and analysis standpoint, as well as for safety monitoring. Voltage transformers bring voltage levels into a range compatible with the NI C Series devices and protect equipment from excess voltage.

The team considered using traditional PLCs during preliminary phases of the project; however, it became apparent that the system performance requirements, including the high sample rate and real-time processing, would be too much for this traditional form of hardware. Instead, we selected the NI system design platform, including CompactRIO hardware and LabVIEW software because of the flexibility and deterministic timing capabilities of CompactRIO and the diverse offering of high-performance I/O modules.

The solution used systems based on the NI cRIO-9024 embedded real-time controller with the NI cRIO-9118 backplane and the NI cRIO-9082 controller for this project. The analog input cards used were 9215 modules. To monitor, analyze, alarm, and communicate, the CompactRIO devices were programmed using the LabVIEW Real-Time and LabVIEW FPGA (field-programmable gate array) development modules. This allowed the system to deterministically perform each of these functions in parallel threads. With data being acquired at 51.2KS/s and 100KS/s, I derived a solution from the CompactRIO Waveform Reference Library to efficiently transfer high-speed data from the FPGA (for acquisition) to the real-time application for communications and action processing.

Several components of this NI-based solution were critical to the project's success. First, the LabVIEW FPGA Module made it possible to implement a system responsible for identifying unsafe electrical conditions and reporting these conditions back to the control systems. Second, simultaneously sampling data across input channels using the NI 9215 analog input module, combined with the accuracy of the NI 9467 GPS module, made timing synchronization between all 72 CompactRIO devices accurate within 100 ns. This was especially beneficial when correlating data from multiple laboratories across the entire 183,000 square foot facility, where testing areas are separated and monitored by different CompactRIO devices. Third, with the processing power of the CompactRIO real-time controllers (800MHz and 1.33GHz for the 9024 and 9118 respecitvely), the controllers acquired and processed 28 channels of data each at 51,200Hz while managing other functions, such as alarm monitoring and TCP/IP and Modbus communications.

![REDB Hardware](/assets/images/posts/NREL_powerbus.jpg)
>The REDB for AC and DC testing at the new ESIF, which includes CompactRIO hardware is pictured.
_Image: [NREL](https://nrel.gov)_

I ended up developing and compiling more than seven custom FPGA bitfiles for this project. The individual compile time for each FPGA application averaged 1.5 hours. Furthermore, prior to releasing final versions of the FGPA applications, several preliminary compilations were necessary to account for project scope changes and shifting requirements, as with most consulting projects. To counter this, I leveraged the LabVIEW FPGA Compile Cloud Service to compile the FPGA applications, which saved valuable developer time on the project. With the LabVIEW FPGA Compile Cloud Service, I was able to push multiple FPGA builds to an external server managed by NI, compile code in parallel, free up developer machines for other tasks, and drastically shorten compile times (2.6 to 5.3 times shorter).

With each of the bitfiles compiled, each and every cRIO of the same family could be reconfigured on the fly to load in different functionality and dynamically adjust to NREL's research needs.

### Solution Benefits

Overall, the my solution delivered the following benefits:

-   High-speed data acquisition, which provides a more accurate representation of the effects individual experiments may have on the grid
-   Correlated data from synchronized systems distributed throughout the ESIF, enabling researchers to better understand multilab experiments and characterize the building's electrical profile
-   Easily reconfigurable virtual power meters and CompactRIO systems that can be configured as AC or DC devices without recompiling or reimaging the controllers
-   A transparent and flexible architecture for future expansion, including features to send data to third-party systems through standard communication protocols such as TCP/IP and Modbus
-   Safe emergency-stop monitoring, implemented in dedicated FPGA code
-   Dynamically configurable analysis algorithms (virtual metering objects), enabled by the deterministic real-time processing capability of CompactRIO hardware for analyzing electrical characteristics for safety violations and in simulating complex circuit breaker logic

### Project Conclusions

Using CompactRIO and LabVIEW, I quickly developed a prototype and responded to customer questions and expectations for a distributed power monitoring solution. Changes in scope and requirements as a result of discoveries made mid-project had minimal effect on the schedule because of the shortened development time achieved using the graphical system design approach.

With the CompactRIO platform and the LabVIEW Real-Time Module, I created the most efficient real-time system possible, which performed considerably more processing on the distributed controllers when compared to traditional PLCs.

By using a complete top-to-bottom NI solution, I aggressively executed the project, leading to a solution for NREL that was ahead of schedule and delivered under budget.


### References
The original paper was published here:
* [https://www.digitalengineering247.com/article/creating-high-speed-electrical-analysis-for-energy-research/](https://www.digitalengineering247.com/article/creating-high-speed-electrical-analysis-for-energy-research/)