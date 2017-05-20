# 1P1Q-screening-estimates-the-complex-voltage-V-vector-following-a-generator-disturbance
1P1Q screening estimates the complex voltage V vector following a disturbance. This project considers either an outage if generator 2 or generator 3 , but not both, affecting the voltage. The program flow and algorithm is as follows:


Run pre-contingency fast-decoupled XB version power flow analysis

Obtain base case complex voltage vector V

Ask the user to select a valid generator (either 2 or 3) to be out

Delete the user selected generator from the gen data structure

Edit the radial branch reactance and resistance of the generator out to be near infinity*

Determine Bp,Bpp,Sbus,Ybus,Yf,Yt

Determine bus types (pv, pq values)

Perform 1P half=iteration

	Compute real power mismatch and delP
	
	Determine swing bus
	
	Remove swing bus from Bp matrix
	
	Creates temporary Vm voltage magnitudes and removes the swing bus
	
	Computes delTheta
	
	Augments delTheta for the swing bus
	
	Updates the complex voltage
	
Perform 1Q half-iteration

	Determines the swing bus
	
	Removes swing and pv buse(s) from Bpp and Vm matrices
	
	Computes Reactive Power Mismatch
	
Computes delVmag

Augment the delVmag for the swing and pv bus(s) 

Update the complex voltage

Compute Branch flows

	Reads data and converts to internal bus numbering
	
	Calculates complex power at from branch
	
	Calculates complex power at the to branch
	
Display Branch flows

	Prints the post-contingency branch flows at from and to ends in MATLAB
	

* The author found out that to approximate the 1P1Q bus flows to that of the AC solution, that the outage generator branch had to be modeled as “almost-off” so that power would not want to flow there. The pre-contingency solution considered it in service, however, when the generator is out, there is no load and incentive for the power to flow down the node to the bus. The AC solution correctly assigned a 0 flow to the post-contingency solution, but in the 1P1Q process, without the branch impedances taken to infinity, there would be >0 (big number) of branch flow on that branch, which does not make sense. By changing the branch impedance to near infinity, it corrects the current calculations and hence the power flows. 


Explanation of Results: 

Overall the 1P1Q seems to be a good approximation for the generator outage. The highest error approximations are seen at the swing bus, since the swing bus accounts for bringing the system back into swing after the outage. The branches 1-4 and 5-7 are to most error prone, also because they are main avenues for power to flow from generation to load. When generator 2 was outages, the radial branch 2-7 was treated as infinite branch with no power going into it. Since there is no load or incentive for the power to flow there, the MW, MVAR, and MVA values are at zero. The same can be said for generator 3 outage and branch 3-9. 

Source code for computing the 1P half-iteration. 

This is attached in the WinZip file called “Pit.m”.

Source code for computing the 1Q half-iteration. 

This is attached in the WinZip file called “Qit.m”.

Source code for computing the branch MVA flows given the complex V estimate. 

This is attached in the WinZip file called “computebranchflows.m”.

Script file for generating all results. 

The results were mostly exported into excel for analysis. The“Project3.xls”file is attached in the same WinZip file

Brief conclusions for project.

The 1P1Q method produced a good estimation for the generator outage compared to the AC solution. The most error in approximation came on the radial branch leading to the swing bus and the branch leading to the load. The method estimated both the MW and MVAR in good approximation. The results of the bus, Vmagnitude, and Vangles (in radians) were outputted in MATLAB after each 1P and 1Q half-iteration for a generator outage. The updated estimated complex V was then used to calculate the complex power branch flows. The post-contingency branch flows for the 1P1Q method is outputted at the end of the 1P1Q program. A separate program called “program3ac.m” runs the AC portion of the power flow analysis. It is important that before you run the AC solution, that the generator to be out, is commented out of the gen[] data structure in the wscc9bus.m file and saved. The AC solution looks only at the structure of the bus. The results of the AC power flow program will display the same complex branch power flows which are in good approximation to the 1P1Q method flows. The comparison of the flow values between 1P1Q and AC was done in excel. The excel file is attached for your reference. 

