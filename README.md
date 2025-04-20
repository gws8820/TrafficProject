# Traffic Controller System on Nexys A7 FPGA

## Project Overview

This project implements a comprehensive traffic light control system on the Digilent Nexys A7 FPGA board using Verilog HDL. 
The system includes advanced features such as VIP priority signaling and a night mode with light sensor via SPI communication.
There are two ways to control this system:
- Using the physical switches and buttons on the FPGA board
- A IP Block contains register map accessible via the AMBA APB bus protocol

## Demo Video

Check out our demonstration video on [this link](https://youtu.be/cJCa-mshHHc?si=9qGXXiUtBk--kC9z)

## Key Features

* **Basic Traffic Light Control:** Implements standard traffic light sequences for vehicles and pedestrians at an intersection.
* **VIP Mode:** Allows interruption of the normal traffic cycle to grant priority to a specific path upon receiving a VIP request.
* **Night Mode:**
  * Includes an SPI master module (spi_master.v) to interface with 10-bit MCP3004 ADC for light sensing. 
  * Automatically enters and exits night mode based on external light sensor input.
  * Pedestrian signals are deactivated, and vehicle signal priority can dynamically adjust based on simulated traffic camera inputs.
* **Control Interfaces:**
  * Direct control using the physical switches and buttons available on the Nexys A7 board (`fpga_traffic_controller.v`).
  * Control via an AMBA APB bus interface, providing register-level access for configuration and status monitoring (`apb_traffic_controller.v`). This module is designed to be easily integrated as an IP core in larger systems.
      
## Traffic Signal Sequences

### Standard Vehicle Signal Sequence
* Green: 10 seconds
* Yellow: 1 second
* Left Turn: 5 seconds
* Yellow: 1 second
* Red: 17 seconds

### VIP Interrupt (Priority 0)
* Yellow transition period: 1 second when entering/exiting VIP mode
* Waits if pedestrian crossing is active (active condition not met)
* VIP path gets continuous Green signal
* When exiting VIP mode:
  * If Left turn was at 0-3.5 seconds: Left turn resumes (rollback)
  * If Left turn was at 3.6-5 seconds: Starts with Red (skip)

### Night Mode Interrupt (Priority 1)
* Activates when light sensor reading rises over threshold of 800 (10-bit, higher is darker)
* Yellow transition period: 1 second when entering/exiting night mode
* Waits if pedestrian crossing is active (active condition not met)
* Waiting vehicle lanes get Green signal
* If multiple lanes are waiting, priority is reassigned every 10 seconds

## Requirements

* Digilent Nexys A7 FPGA Board (XC7A100T or XC7A50T).
* An external expansion board connected to the Pmod JA and JB connectors, designed to interface with traffic light LEDs and a light sensor. (Refer to `References/extend_board_pinmap.xlsx` and `References/extend_board_sch.png` for connection details).
* Xilinx Vivado Design Suite.
* (If using the APB interface) A system integrating an APB master (e.g., a MicroBlaze softcore processor).

## Project Structure

* `Constraints/`: Contains Xilinx Design Constraints (`.xdc`) files for FPGA pin assignments and timing constraints.
* `IP/`: Includes the source files and packaging information (`component.xml`, `xgui/`) for the `apb_traffic_controller` IP core.
* `References/`: Repository for external documentation and reference materials, such as the AMBA APB specification, ADC datasheet, Nexys A7 manual, pin maps, and the register map.
* `Sources/`: Contains the core Verilog HDL source files for the traffic logic, controllers, SPI master, and simulation testbenches.

## Getting Started

1. Clone this repository to your local machine.
2. Launch Xilinx Vivado Design Suite.
3. Create a new Vivado project, selecting your specific Nexys A7 board variant (XC7A100T or XC7A50T) as the target FPGA device.
4. Add all `.v` files from the `Sources/` directory to your project sources.
5. Add the appropriate `.xdc` file from the `Constraints/` directory to your project constraints, selecting the file that matches your board and desired control method (physical I/O or APB).
6. **If you intend to use the APB interface:**
   * In Vivado's Project Settings, navigate to "IP" -> "Repository" and add the `IP/` directory as a new IP repository.
   * In your Block Design or top-level HDL, instantiate the `apb_traffic_controller` IP core and connect its APB interface and external I/O ports to your system.
7. Create a top-level module for your design, or set one of the provided modules (`fpga_traffic_controller.v` for physical I/O control, or your custom APB system top-level) as the top-level and connect it to the board's physical I/O or your internal APB system.
8. Run Synthesis, Implementation, and generate the Bitstream.
9. Use the Vivado Hardware Manager to download the generated Bitstream file to your Nexys A7 board.

## Usage

If you are using `fpga_traffic_controller.v` as your top-level module, you will control the traffic light system using the physical switches and buttons on the Nexys A7 board. Consult the selected XDC file to understand the specific mapping of each switch and button to the system's control signals.

<img src="References/nexys-a7-board-product.avif" alt="Nexys A7 Board">

* **Reset:** Mapped to a BCNU(M18) button. Toggle to change state.
* **Start:** Mapped to a BCNC(N17) button. Toggle to change state.
* **VIP Path Select:** Mapped to SW15 (North/South), SW14 (East/West)
* **Traffic Camera Input:** Mapped to SW13 (North/South), SW12 (East/West)
* **SPI Channel Select:** Mapped to SW2, SW1, SW0, selects light sensor to use.

If you are using `apb_traffic_controller.v`, you will control the system by reading from and writing to its internal registers via an APB master.

* **Control Register (CTRL_INDEX, Base Address 0x1000_2000):**
  * Bit 0: `start` (Write 1 to start, 0 to stop the traffic sequence)
  * Bit 1: `isvip` (Write 1 to enable VIP mode, 0 to disable)
  * Bit 2: `vip_path_index` (Selects the priority path in VIP mode: 0 for path 0, 1 for path 1)
  * Bits 4:3: `traffic_camera[1:0]` (Simulates traffic camera input for night mode priority logic)
  * Bits 6:5: `channel[1:0]` (Selects the SPI channel for the light sensor)
* **Status Register (STATUS_INDEX, Base Address 0x1000_2004):**
  * Bit 0: `isnight` (Read 1 if in night mode, 0 otherwise)

## Contributing

Contributions to this project are welcome! If you have suggestions for improvements, bug fixes, or new features, please feel free to open an issue or submit a Pull Request.

## License

See [LICENSE](LICENSE) for details