from tkinter import *
import operator ##used for look-up table for operations

###define the main/root window(our reference)
root=Tk()
root.title("The Simple Calculator")
root.geometry("600x700")

###define global variables so operaation fuctions can modify them
saved_value=0
current=0
operator_dic={
    "+":operator.add,
    "*":operator.mul,
    "/":operator.truediv
} ##look up table for operations
result_value=0

###definitions of functions/operators
def Selected_Num(numb):
    '''
    Will take current value in entry box and append 'numb' parameter next entered digit
    '''
    currently=Entry_Box.get()
    Entry_Box.delete(0,END)
    Entry_Box.insert(0,str(currently)+ str(numb))

def operation(op):
    '''
    This will set the 'operator' variable to ADD(+)
    '''
    global operator
    operator=op
    clear()

def Equal():
    '''
    Will take the value saved intially, and take the value currently in the entry box
    and use the look-up table to perform current 'operator' 
    operation. Update history box to show work.
    '''
    global saved_value, current, result_value
    current=Entry_Box.get()
    Entry_Box.delete(0,END)
    try:
        result_value=operator_dic[operator]( float(saved_value) , float(current))
        Entry_Box.insert(0,result_value)
        update_history()
    except ZeroDivisionError:
        history.insert(END, "ERROR: Div by Zero"+"\n")


    

def clear():
    '''
    Saves the value currently in entry box to "saved_value" variable and clears the box for enxt value
    '''
    global saved_value
    saved_value=Entry_Box.get()
    Entry_Box.delete(0,END)

def update_history():
    '''
    Takes the intially saved variable, current value in entry box and operator to created a history log
    '''
    global saved_value, current, operator
    history.insert(END, str(saved_value)+ str(operator)+ str(current)+ '\n'+"="+ str(result_value)+'\n')  

###define textbox to see results
Entry_Box= Entry(root, width=50, borderwidth=5)
Entry_Box.grid(row=0, column=0, columnspan=3, padx=5, pady=10)

###define history textbox to show timeline of our operations
history= Text(root, width=25, height=40, wrap=WORD, background="white")
history.grid(row=0, column=3, rowspan=6, sticky='w')

###create number butttons and operation buttons
Num_Buttons=[Button(root, text=str(Digit), padx=40, pady=40, command=lambda: Selected_Num) for Digit in range(10)] #list of button objects
Add_Button=Button(root, text="+", padx=40, pady=40, command=lambda: operation("+"))
Mult_Button=Button(root, text="*", padx=40, pady=40, command=lambda: operation("*"))
Div_Button=Button(root, text="/", padx=40, pady=40, command=lambda: operation("/"))
Equal_Button=Button(root, text="=", padx=40, pady=40, command=lambda: Equal())


###assign functions to number buttons because the list of objects wont assign the functions in the loop
Num_Buttons[0]["command"]=lambda: Selected_Num(0)
Num_Buttons[1]["command"]=lambda: Selected_Num(1)
Num_Buttons[2]["command"]=lambda: Selected_Num(2)
Num_Buttons[3]["command"]=lambda: Selected_Num(3)
Num_Buttons[4]["command"]=lambda: Selected_Num(4)
Num_Buttons[5]["command"]=lambda: Selected_Num(5)
Num_Buttons[6]["command"]=lambda: Selected_Num(6)
Num_Buttons[7]["command"]=lambda: Selected_Num(7)
Num_Buttons[8]["command"]=lambda: Selected_Num(8)
Num_Buttons[9]["command"]=lambda: Selected_Num(9)

###assign location of buttons
i=1
for rowposition in range(3,0,-1):
    for colposition in range(3):
        Num_Buttons[i].grid(row=rowposition, column=colposition)
        i+=1
Num_Buttons[0].grid(row=4, column=1)
Equal_Button.grid(row=4, column=2)
Add_Button.grid(row=4, column=0)
Mult_Button.grid(row=5, column=0)
Div_Button.grid(row=6, column=0)

###End of window loop (keeps the window on screen)
root.mainloop()

###anything down here will run after main window is closed (TEST AREA)