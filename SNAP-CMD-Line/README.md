# NOTE
These are steps for installing SNAP on Ubuntu.<br> 
PLEASE NOTE<br>
All references to SNAP refer to Sentinel Application Platform (SNAP), not snapcraft (alias snap) which is one of the package managers that come with Ubuntu, please be aware of that and keep things seperate from one another, when installing SNAP. you may break the snap package.
# Resources
- open jdk: https://vitux.com/how-to-setup-java_home-path-in-ubuntu/
- snap docker builds: https://hub.docker.com/r/mundialis/esa-snap (docker-hub)

# Requirements
- Maven 
- Java Dev Kit 11
- python 3.6 (use ubuntu 18.01 for docker) desktop may need to create a conda env, or install python 2.7.x

# Flow
- make sure JDK is on path 
```sh
java --version
```
## Steps in flow chart fmt

<hr>

```mermaid
flowchart TD
A[Start]-->B{Is OpenJDK 11 installed?}
B --> |No| C[Install OpenJDK 11]
B -->|Yes| F
C --> D[Set JAVA_HOME]
D --> E[Add JAVA_HOME\bin to PATH]
E --> F{Is MAVEN Installed}
F --> |Yes| H
F --> |No| G[Install Maven]
G --> H[Set Snap Version]
H --> J[Set Java Max mem]
J --> K[Clone and build wheel file for java bridge for python]
K-->L[grab installer from ESA for current version of SNAP - ESA]
L -->M[Run Installers and configure SNAP]
M-->N[Add SNAP to PATH]
````