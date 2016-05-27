#include <omnetpp.h>
#include <math.h>

class MobileNode: public cSimpleModule {
protected:
    double playgroundLat, playgroundLon;  // NW corner of playground, in degrees
    double playgroundHeight, playgroundWidth;  // in meters
    double timeStep;

    std::string color;
    std::string modelURL;
    unsigned int trailLength;
    double modelScale;
    bool showTxRange;
    double txRange;
    double speed;

    int roadsidexy[2][2] = {{900,900},{1000,1000}};//路边单元坐标

    // node position and heading (speed is constant in this model)
    double heading; // in degrees
    double x, y; // in meters, relative to playground origin
public:
    MobileNode();
    virtual ~MobileNode();

    double getX() {
        return x;
    }
    double getY() {
        return y;
    }

protected:
    virtual void initialize();
    virtual void handleMessage(cMessage *msg);
    virtual void moveto();
};
Define_Module(MobileNode);

MobileNode::MobileNode() {
}

MobileNode::~MobileNode() {
}

void MobileNode::initialize() {

}

void MobileNode::handleMessage(cMessage *msg) {
     bubble("sending!");
}

void MobileNode::moveto() {
//    heading += 120 * (dblrand() - 0.5) * timeStep;
//    heading = fmod(heading + 360, 360);
    heading  =  145;
    // update position
    double vx = sin(heading * 3.1415926 / 180) * speed;
    double vy = -cos(heading * 3.1425926 / 180) * speed;
    x += vx * timeStep;
    y += vy * timeStep;

    // keep the node inside the playground
    if (x < 0) {
        x = 0;
        heading = 360 - heading;
    }
    if (x > playgroundWidth) {
        x = playgroundWidth;
        heading = 360 - heading;
    }
    if (y < 0) {
        y = 0;
        heading = 180 - heading;
    }
    if (y > playgroundHeight) {
        y = playgroundHeight;
        heading = 180 - heading;
    }

    getDisplayString().setTagArg("p", 0, x);
    getDisplayString().setTagArg("p", 1, y);
}
