//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Lesser General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Lesser General Public License for more details.
// 
// You should have received a copy of the GNU Lesser General Public License
// along with this program.  If not, see http://www.gnu.org/licenses/.
// 

import org.car2x.veins.nodes.*;
import org.car2x.veins.nodes.Scenario;

import inet.linklayer.ethernet.EtherHub;
import inet.networklayer.configurator.ipv6.FlatNetworkConfigurator6;
import inet.node.ipv6.Router6;
import inet.node.wireless.AccessPoint;
import inet.node.xmipv6.CorrespondentNode6;
import inet.node.xmipv6.HomeAgent6;
import inet.node.xmipv6.WirelessHost6;
import inet.physicallayer.ieee80211.packetlevel.Ieee80211ScalarRadioMedium;
import inet.physicallayer.contract.packetlevel.IRadioMedium;

channel fiberline extends ned.DatarateChannel
{
    parameters:
        delay = 1us;
        datarate = 512Mbps;
}

channel ethernetline extends ned.DatarateChannel
{
    parameters:
        delay = 0.1us;
        datarate = 100Mbps;
}

network RSUExampleScenario extends Scenario
{
    parameters:
        double total_mn;
        double total_cn;
        **.mgmt.numChannels = 5;
        string mediumType = default("IdealRadioMedium");

        @display("bgb=$playgroundSizeX,$playgroundSizeY");
    submodules:
        configurator: FlatNetworkConfigurator6 {
            parameters:
                @display("p=763,53");
        }
        radioMedium: <mediumType> like IRadioMedium {
            @display("p=309,24");
        }
        Home_Agent: Router6 {
            parameters:
                @display("p=1200,1229;i=abstract/router");
        }
        R_1: Router6 {
            parameters:
                @display("p=1866,1727");
        }
        R_2: Router6 {
            parameters:
                @display("p=1506,1600");
        }
        R_3: Router6 {
            parameters:
                @display("p=1245,1455");
        }
        R_4: Router6 {
            parameters:
                @display("p=433.3,633.3");
        }
        R_5: Router6 {
            parameters:
                @display("p=1099.9,633.3");
        }
        R_6: Router6 {
            parameters:
                @display("p=1766.7,633.3");
        }
        R_7: Router6 {
            parameters:
                @display("p=533.9,1199.3");
        }
        R_8: Router6 {
            parameters:
                @display("p=1866.7,1199.3");
        }
        R_9: Router6 {
            parameters:
                @display("p=333,1699.3");
        }
        R_10: Router6 {
            parameters:
                @display("p=999,1699.3");
        }
        ap_home: myrsu {
            	@display("i=device/accesspoint;is=n");
        }
        ap_1: myrsu {
            @display("i=device/accesspoint;is=n");
        }
        ap_2: myrsu {
            @display("i=device/accesspoint;is=n");
        }
        ap_4: myrsu {
            @display("i=device/accesspoint;is=n");
        }
        ap_5: myrsu {
            @display("i=device/accesspoint;is=n");
        }
        ap_6: myrsu {
            @display("i=device/accesspoint;is=n");
        }
        ap_7: myrsu {
            @display("i=device/accesspoint;is=n");
        }
        ap_8: myrsu {
            @display("i=device/accesspoint;is=n");
        }
        ap_9: myrsu {
            @display("i=device/accesspoint;is=n");
        }
        ap_10: myrsu {
            @display("i=device/accesspoint;is=n");
        }
        CN[total_cn]: CorrespondentNode6;
        hub: EtherHub {
            parameters:
                @display("p=1306,1982;i=device/hub_s");
        }
    connections allowunconnected:

                         //Home_Agent.ethOut++ --> ethernetline --> R_1.ethIn++;
                         //Home_Agent.ethIn++ <-- ethernetline <-- R_1.ethOut++;

        R_1.ethg++ <--> ethernetline <--> R_2.ethg++;
        R_2.ethg++ <--> ethernetline <--> R_3.ethg++;
        Home_Agent.ethg++ <--> ethernetline <--> R_5.ethg++;
        R_4.ethg++ <--> ethernetline <--> R_5.ethg++;
        R_5.ethg++ <--> ethernetline <--> R_6.ethg++;
        R_7.ethg++ <--> ethernetline <--> Home_Agent.ethg++;
        R_8.ethg++ <--> ethernetline <--> Home_Agent.ethg++;
        R_9.ethg++ <--> ethernetline <--> R_10.ethg++;
        R_10.ethg++ <--> ethernetline <--> R_3.ethg++;

                                                       //R_2.ethOut++ --> ethernetline --> R_3.ethIn++;
                                                       //R_2.ethIn++ <-- ethernetline <-- R_3.ethOut++;

        Home_Agent.ethg$o++ --> ethernetline --> R_2.ethg$i++;
        Home_Agent.ethg$i++ <-- ethernetline <-- R_2.ethg$o++;

        for i=0..total_cn-1 {
            CN[i].ethg$o++ --> ethernetline --> hub.ethg$i++;
            CN[i].ethg$i++ <-- ethernetline <-- hub.ethg$o++;
        }

        hub.ethg++ <--> ethernetline <--> R_2.ethg++;

                                                    //R_1.ethOut++ --> ethernetline --> CN.ethIn++;
                                                    //R_1.ethIn++ <-- ethernetline <-- CN.ethOut++;

//        AP_Home.ethg$o++ --> ethernetline --> Home_Agent.ethg$i++;
//        AP_Home.ethg$i++ <-- ethernetline <-- Home_Agent.ethg$o++;
//
//        AP_1.ethg++ <--> ethernetline <--> R_1.ethg++;
//		R_1.rou_ap <--> ap_1.ap_rou;
//		Home_Agent.rou_ap <--> ap_home.ap_rou;

        ap_home.ethg$o++ --> ethernetline --> Home_Agent.ethg$i++;
        ap_home.ethg$i++ <-- ethernetline <-- Home_Agent.ethg$o++;

        ap_1.ethg$o++ --> ethernetline --> R_1.ethg$i++;
        ap_1.ethg$i++ <-- ethernetline <-- R_1.ethg$o++;
        
        ap_2.ethg$o++ --> ethernetline --> R_2.ethg$i++;
        ap_2.ethg$i++ <-- ethernetline <-- R_2.ethg$o++;
        
        ap_4.ethg$o++ --> ethernetline --> R_4.ethg$i++;
        ap_4.ethg$i++ <-- ethernetline <-- R_4.ethg$o++;
        
        ap_5.ethg$o++ --> ethernetline --> R_5.ethg$i++;
        ap_5.ethg$i++ <-- ethernetline <-- R_5.ethg$o++;
        
        ap_6.ethg$o++ --> ethernetline --> R_6.ethg$i++;
        ap_6.ethg$i++ <-- ethernetline <-- R_6.ethg$o++;
        
        ap_7.ethg$o++ --> ethernetline --> R_7.ethg$i++;
        ap_7.ethg$i++ <-- ethernetline <-- R_7.ethg$o++;
        
        ap_8.ethg$o++ --> ethernetline --> R_8.ethg$i++;
        ap_8.ethg$i++ <-- ethernetline <-- R_8.ethg$o++;
        
        ap_9.ethg$o++ --> ethernetline --> R_9.ethg$i++;
        ap_9.ethg$i++ <-- ethernetline <-- R_9.ethg$o++;
        
        ap_10.ethg$o++ --> ethernetline --> R_10.ethg$i++;
        ap_10.ethg$i++ <-- ethernetline <-- R_10.ethg$o++;
                                                        //AP_2.ethOut++ --> ethernetline --> R_2.ethIn++;
                                                        //AP_2.ethIn++ <-- ethernetline <-- R_2.ethOut++;

                                                        //AP_3.ethOut++ --> ethernetline --> R_3.ethIn++;
                                                        //AP_3.ethIn++ <-- ethernetline <-- R_3.ethOut++;
}
