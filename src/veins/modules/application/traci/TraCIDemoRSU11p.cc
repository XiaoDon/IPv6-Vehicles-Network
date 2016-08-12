//
// Copyright (C) 2006-2011 Christoph Sommer <christoph.sommer@uibk.ac.at>
//
// Documentation for these modules is at http://veins.car2x.org/
//
// This program is free software; you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation; either version 2 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
//

#include "veins/modules/application/traci/TraCIDemoRSU11p.h"
#include "inet/networklayer/ipv6/IPv6.h"
#include "inet/networklayer/ipv6/IPv6Datagram.h"
#include "inet/linklayer/common/MACAddress.h"
#include "inet/applications/udpapp/UDPBasicApp.h"
#include <string>

using Veins::AnnotationManagerAccess;
using inet::IPv6;
using inet::IPv6Datagram;
using inet::MACAddress;
using inet::UDPBasicApp;
using std::string;

class TraCIDemoRSU11p;

Define_Module(TraCIDemoRSU11p);

void TraCIDemoRSU11p::initialize(int stage) {
    BaseWaveApplLayer::initialize(stage);
    if (stage == 0) {
        mobi = dynamic_cast<BaseMobility*>(getParentModule()->getSubmodule(
                "mobility"));
        ASSERT(mobi);
        annotations = AnnotationManagerAccess().getIfExists();
        ASSERT(annotations);
        sentMessage = false;
    }
}

void TraCIDemoRSU11p::onBeacon(WaveShortMessage* wsm) {

}

void TraCIDemoRSU11p::onData(WaveShortMessage* wsm) {
    findHost()->getDisplayString().updateWith("r=16,green");
    //===============
//	IPv6 *ipv6 = new IPv6();
//	cModule *targetModule = getParentModule()->getSubmodule("networkLayer",0)->getSubmodule("ipv6",0);
//	ipv6 = check_and_cast<IPv6 *>(targetModule);
//	char *ipstr = "hello";
//	IPv6Datagram *ipv6data = new IPv6Datagram();
//	MACAddress *macadd = new MACAddress("0A:AA:00:00:00:07");
//	ipv6->sendDatagramToOutput(ipv6data,nullptr,*macadd);
//	cMessage *ms = new cMessage("open");
//	ms->setKind(1);
//	TCPOpenCommand *cmd = new TCPOpenCommand();
//	cmd->setLocalPort(1000);cmd->setRemotePort(1000);
//	char ipstr[] = "10:AA:00:00:A1:01";
//	IPv6Address* ipv6add = new IPv6Address(ipstr);L3Address* l3add = new L3Address(*ipv6add);
//	cmd->setLocalAddr(*l3add);
//	char ipstr1[] = "10:AA:00:00:A1:a";
//	IPv6Address* ipv6add1 = new IPv6Address(ipstr1);L3Address* l3add1 = new L3Address(*ipv6add1);
//	cmd->setRemoteAddr(*l3add1);
//	cmd->setConnId(111);cmd->setDataTransferMode(1);
//	ms->setControlInfo(cmd);
//	tcpapp->sendBack(ms);
    //===============
	cModule *targetModule = getParentModule()->getSubmodule("udpApp",0);
	udpapp = check_and_cast<UDPBasicApp *>(targetModule);
	udpapp->messag = (wsm->getWsmData());
//	sleep(2);
//	udpapp->messag = ("666");
    //模拟远程通信，通知其他路边单元进行广播
//	string apname[3] = {"ap_home","ap_1","ap_2"};
//	for(int i =0;i<3;i++){
//	    cModule *targetModule1 = simulation.getModuleByPath(apname[i].c_str())->getSubmodule("appl",0);
//	}

//	simulation.getContextModule()->getParentModule()->bubble(">>>>");
    //===============
    annotations->scheduleErase(1,
            annotations->drawLine(wsm->getSenderPos(),
                    mobi->getCurrentPosition(), "blue"));

    if (!sentMessage)
        sendMessage(wsm->getWsmData());

    /////////////////////
//    cModule *targetModule1 = simulation.getModuleByPath("ap_2")->getSubmodule(
//                "appl", 0);
//    rsuappl = check_and_cast<TraCIDemoRSU11p *>(targetModule1);
//    rsuappl->sendMessage(wsm->getWsmData());

    ////////////////////////

}

void TraCIDemoRSU11p::sendMessage(std::string blockedRoadId) {
    Enter_Method_Silent
    ();
    sentMessage = true;
//    findHost()->bubble(blockedRoadId.c_str());	//rsu间远程调用结果显示
    t_channel channel = dataOnSch ? type_SCH : type_CCH;
    WaveShortMessage* wsm = prepareWSM("data", dataLengthBits, channel,
            dataPriority, -1, 2);
    wsm->setWsmData(blockedRoadId.c_str());
    sendWSM(wsm);
}
void TraCIDemoRSU11p::sendWSM(WaveShortMessage* wsm) {
    sendDelayedDown(wsm, individualOffset);
}
void TraCIDemoRSU11p::handleMessage( cMessage* msg){
    if(msg->getName() == "appludp"){
        sendMessage(msg->getName());
    }
}
