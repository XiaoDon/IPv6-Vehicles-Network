//
// Copyright (C) 2008 Christoph Sommer <christoph.sommer@informatik.uni-erlangen.de>
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

package org.car2x.veins.nodes;

import org.car2x.veins.nodes.*;
import inet.node.wireless.*;

module RSUnit
{
        @display("i=device/accesspoint;is=n");
    gates:
        inout ethg[] @labels(EtherFrame-conn);
        input veinsradioIn; // gate for sendDirect
    submodules:
		RSU_1: RSU{
		    parameters:
		    	@display("b=10,10,oval");
		}
		AP: AccessPoint{
		    parameters:
		    	@display("b=10,10,oval");
		};
    connections:
        ethg++ <--> AP.ethg++;
        veinsradioIn --> RSU_1.veinsradioIn;
}
