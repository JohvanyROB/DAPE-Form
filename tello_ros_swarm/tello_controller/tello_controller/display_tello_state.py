import rclpy
from rclpy.node import Node

from tello_msgs.msg import FlightData

from threading import Thread
import tkinter as tk


class DisplayTelloState(Node):
    def __init__(self):
        Node.__init__(self, "display_tello_state")
        self.declare_parameter("nb_uavs", rclpy.Parameter.Type.INTEGER)
        self.nb_uavs = self.get_parameter("nb_uavs").value
        self.batt_lvls = [None for i in range(self.nb_uavs)]
        states_cb = [self.state1_cb, self.state2_cb, self.state3_cb, self.state4_cb]
        for i in range(self.nb_uavs):
            self.create_subscription(FlightData, f"/drone{i+1}/flight_data", states_cb[i], qos_profile=1)
                
        Thread(target=self.display_states, daemon=True).start()

        self.create_timer(timer_period_sec=1.0, callback=self.update_display)
        
    
    def state1_cb(self, msg):
        """ Callback function that gets the state of drone1 """
        self.batt_lvls[0] = msg.bat
    

    def state2_cb(self, msg):
        """ Callback function that gets the state of drone2 """
        self.batt_lvls[1] = msg.bat

    
    def state3_cb(self, msg):
        """ Callback function that gets the state of drone3 """
        self.batt_lvls[2] = msg.bat

    
    def state4_cb(self, msg):
        """ Callback function that gets the state of drone4 """
        self.batt_lvls[3] = msg.bat 
    

    def display_states(self):
        """ Display the current battery level of each UAV """
        self.create_gui()
        self.app.mainloop()
    

    def create_gui(self):
        """ Configure the GUI """
        self.app = tk.Tk()
        self.app.geometry("200x150")
        self.app.title("UAVs flight data")
        self.app.config(bg="white")
        self.app.resizable(False, False)
        # self.config_title_frame()
        self.config_batt_frame()
    

    def config_title_frame(self):
        # self.title_frame = tk.Frame(self.app, bg="white")
        # self.title_frame.place(relheight=0.25, relwidth=1)
        # tk.Label(self.title_frame, text="UAV states", bg="black", fg="white", font=("Helvetica", 20)).place(relx=0.3, relwidth=0.4, relheight=1)
        pass


    def config_batt_frame(self):
        """ Configure the labels containing the battery level data for each UAV """
        self.batt_frame = tk.Frame(self.app, bg="white")
        self.batt_frame.place(relwidth=1, relheight=1)
        self.batt_lvl_labels = [tk.Label(self.batt_frame, text=f"Drone {i+1}: --- %", font=("Helvetica", 20), bg="white", fg="black") for i in range(self.nb_uavs)]
        if self.nb_uavs == 4:
            self.batt_lvl_labels[0].place(relx=0.05, rely=0.05, relwidth=0.9, relheight=0.1875)
            self.batt_lvl_labels[1].place(relx=0.05, rely=0.2875, relwidth=0.9, relheight=0.1875)
            self.batt_lvl_labels[2].place(relx=0.05, rely=0.525, relwidth=0.9, relheight=0.1875)
            self.batt_lvl_labels[3].place(relx=0.05, rely=0.7625, relwidth=0.9, relheight=0.1875)
        elif self.nb_uavs == 3:
            self.batt_lvl_labels[0].place(relx=0.05, rely=0.05, relwidth=0.9, relheight=0.267)
            self.batt_lvl_labels[1].place(relx=0.05, rely=0.367, relwidth=0.9, relheight=0.267)
            self.batt_lvl_labels[2].place(relx=0.05, rely=0.684, relwidth=0.9, relheight=0.267)
        elif self.nb_uavs == 2:
            self.batt_lvl_labels[0].place(relx=0.05, rely=0.05, relwidth=0.9, relheight=0.425)
            self.batt_lvl_labels[1].place(relx=0.05, rely=0.525, relwidth=0.9, relheight=0.425)
        else:
            self.batt_lvl_labels[0].place(relx=0.05, rely=0.05, relwidth=0.9, relheight=0.9)

    
    def update_display(self):
        for i, batt_lvl in enumerate(self.batt_lvls):
            if batt_lvl != None:
                if batt_lvl < 30:
                    self.batt_lvl_labels[i].configure(text=f"Drone {i+1}: {batt_lvl} %", fg="red")
                elif batt_lvl < 60:
                    self.batt_lvl_labels[i].configure(text=f"Drone {i+1}: {batt_lvl} %", fg="orange")
                else:
                    self.batt_lvl_labels[i].configure(text=f"Drone {i+1}: {batt_lvl} %", fg="green")


def main(args=None):
    rclpy.init(args=args)

    node = DisplayTelloState()
    try:
        rclpy.spin(node)
    except KeyboardInterrupt:
        pass
    finally:
        node.destroy_node()
        rclpy.shutdown()