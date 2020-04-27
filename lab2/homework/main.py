import tkinter as tk
import cx_Oracle as sql

conn = sql.connect("student", "student", "localhost/xe")
cursor = conn.cursor()

root = tk.Tk()
root.wm_title("title")
root.mainloop()
