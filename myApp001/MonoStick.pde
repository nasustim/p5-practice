import processing.serial.*;

final int LF = 10;        // linefeed（ASCII）

class MonoStick
{
    private Serial port;
    private ArrayList ids;
    private ArrayList twelites;
    public boolean debugMode;

    MonoStick(PApplet p)
    {
        //println(Serial.list());
        String targetPortID = "";
        for (int i = 0; i < Serial.list().length; i++)
        {
            String portID = Serial.list()[i];
            if (portID.substring(0, 18).equals("/dev/cu.usbserial-"))
            {
                targetPortID = portID;
            }
        }

        this.port = new Serial(p, targetPortID, 115200);
        this.ids = new ArrayList();
        this.twelites = new ArrayList();
        this.debugMode = false;
    }
    
    void update()
    {
        if (this.port.available() > 0)
        {
            String data = this.port.readStringUntil(LF);
            //println(data);
            if (data == null)
            {
                return;
            }
            
            String[] s = splitTokens(trim(data), ";");
            if (s.length == 14)
            {
                String id = s[4];
                int x = int(map(int(s[11]),-97,104,-100,100));    //数値調整
                int y = int(map(int(s[12]),-107,97,-100,100));    //数値調整
                int z = int(map(int(s[13]),-108,88,-100,100));    //数値調整
                //int x = int(s[11]);
                //int y = int(s[12]);
                //int z = int(s[13]);

                if (this.ids.indexOf(s[4]) <= -1)
                {
                    this.ids.add(s[4]);

                    Twelite twe = new Twelite(s[4]);
                    this.twelites.add(twe);
                }

                for (int i = 0; i < this.twelites.size(); i++)
                {
                    Twelite twe = (Twelite)this.twelites.get(i);
                    if (twe.id.equals(id))
                    {
                        twe.setData(x, y, z);
                        
                        if (twe.getSpeed() > twe.shakeThreshold)
                        {
                            twe.shakeCount++;
                        }
                    }
                }
            }
        }
        if (this.debugMode)
        {
          this.updateDebugInfo(this.twelites);
        }
    }
    
    ArrayList getTwelites()
    {
        return this.twelites;
    }
    
    Twelite getTwelite(String id)
    {
        if (this.getTweliteNum() <= 0)
        {
            return null;
        }

        Twelite targetTwe = null;
        for (int i = 0; i < this.getTweliteNum(); i++)
        {
            Twelite twe = (Twelite)this.twelites.get(i);
            if (twe.id.equals(id))
            {
                targetTwe = twe;
            }
        }
      
        return targetTwe;
    }
    
    int getTweliteNum()
    {
        return this.twelites.size();
    }
    
    void updateDebugInfo(ArrayList twes)
    {
        fill(0);
        
        int x = 10;
        int y = 10;
        for (int i = 0; i < twes.size(); i++)
        {
            Twelite twe = (Twelite)twes.get(i);
            text("id: "+twe.id, x, y);
            text("x: "+twe.x, x, y+10);
            text("y: "+twe.y, x, y+20);
            text("z: "+twe.z, x, y+30);
            text("speed: "+twe.getSpeed(), x, y+40);
            text("count: "+twe.shakeCount, x, y+50);
            text("degX: "+twe.getDegreeX(), x, y+60);
            text("degY: "+twe.getDegreeY(), x, y+70);
            y += 90;
        }
    }
}

class Twelite
{
    private String id;
    public int x, y, z;
    public int lx, ly, lz;
    public int hx, hy, hz;
    public ArrayList xs;
    public ArrayList ys;
    public ArrayList zs;
    public double filteringFactor;
    public int shakeCount;
    public int shakeThreshold;
    
    Twelite(String id)
    {
        this.id = id;
        this.x = this.y = this.z = 0;
        this.lx = this.ly = this.lz = 0;
        this.hx = this.hy = this.hz = 0;
        this.xs = new ArrayList();
        this.ys = new ArrayList();
        this.zs = new ArrayList();
        this.filteringFactor = 0.8;
        this.shakeCount = 0;
        this.shakeThreshold = 50;
    }
    
    String getID()
    {
        return this.id;
    }
    
    int getDegreeX()
    {
        int d = (int)(90-degrees(acos(float(this.lx)/95)));
        return d;
    }
    
    int getDegreeY()
    {
        int d = (int)(90-degrees(acos(float(this.ly)/95)));
        return d;
    }
    
    int getSpeed()
    {
        int speed = (int)(sqrt(sq(this.x) + sq(this.y) + sq(this.z))) - 100;
        if (speed > -4 && speed < 4)
        {
          speed = 0;
        }
        return speed;
    }
    
    void resetCount()
    {
        this.shakeCount = 0;
    }
    
    int getCount()
    {
        return this.shakeCount;
    }
    
    void setData(int x, int y, int z)
    {
        this.xs.add(this.x);
        this.ys.add(this.y);
        this.zs.add(this.z);
        
        if (this.xs.size() > 10)
        {
            this.xs.remove(0);
            this.ys.remove(0);
            this.zs.remove(0);
        }
        
        if (xs.size() <= 0)
        {
            this.lx = this.hx = x;
            this.ly = this.hy = y;
            this.lz = this.hz = z;
        }
        else
        {
            double ff = this.filteringFactor;
            this.lx = (int)((double)x * ff + ((double)this.lx * (1.0 - ff)));
            this.ly = (int)((double)y * ff + ((double)this.ly * (1.0 - ff)));
            this.lz = (int)((double)z * ff + ((double)this.lz * (1.0 - ff)));
            this.hx = x - this.lx;
            this.hy = y - this.ly;
            this.hz = z - this.lz;
        }

        this.x = x;
        this.y = y;
        this.z = z;
    }
}