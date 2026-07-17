import mysql.connector

def connect_to_db():
    """Establish and return the database connection and cursor."""
    mydb = mysql.connector.connect(
        host="localhost",
        user="root",
        password="",
        database="travel"
    )
    return mydb, mydb.cursor()

def package_choice(username, mydb, mycursor):
    """Handle the package selection and booking process."""
    choice = input("Do you have a budget for the Travel? (y/n): ").strip().lower()
    
    # 1. Fetch the correct packages based on user budget
    if choice == 'y':
        budget = int(input("Enter your budget (INR): "))
        print("Packages in your budget are: \n Package name \t Price \t Package Description")
        sql = "SELECT * FROM package_info WHERE package_price < %s"
        mycursor.execute(sql, (budget,))
    elif choice == 'n':
        print("Available Packages are: ")
        mycursor.execute("SELECT * FROM package_info")
    else: 
        print('Wrong Choice')
        return
        
    # 2. Display the fetched packages
    record = mycursor.fetchall()
    if not record:
        print("No packages found.")
        return
        
    for x in record:
        print(x)
        
    # 3. Handle the booking (Deduplicated logic)
    selected_package = input("Enter the name of the package you want: ")
    sql1 = "INSERT INTO package_choice VALUES(%s, %s)"
    values1 = (username, selected_package)
    mycursor.execute(sql1, values1)
    
    # Commit the transaction so the booking is saved
    mydb.commit() 
    print(f"Thank you for booking the package: {selected_package}. We Hope to see you soon!")

def main():
    mydb, mycursor = connect_to_db()
    
    print("Welcome to Rocket Travel Agency!")
    print("1. Login (already existing user)")
    print("2. Register (new user)")
    
    try:
        choice = int(input("Select your choice: "))
    except ValueError:
        print("Invalid input. Please enter a number.")
        return

    if choice == 1:
        # Simplified Login Logic
        username = input('Enter your Username: ')
        password = input('Enter password: ')
        
        # Query the database directly for the exact user/password match
        sql = "SELECT * FROM user_info WHERE user_name = %s AND user_password = %s"
        mycursor.execute(sql, (username, password))
        
        # fetchone() will return None if no match is found
        user = mycursor.fetchone()
        
        if user:
            print("Welcome ", username, "!")
            package_choice(username, mydb, mycursor)
        else:
            print("Wrong Password/Username, Please try again.")

    elif choice == 2:
        # Registration Logic
        print("Register-")
        name = input("Enter your Name: ")
        user_name = input("Enter Username: ")
        password = input("Enter Password: ")
        
        sql = "INSERT INTO user_info (user_info_name, user_name, user_password) VALUES (%s, %s, %s)"
        val = (name, user_name, password)
        mycursor.execute(sql, val)
        mydb.commit()
        print(mycursor.rowcount, "Successfully Registered.")
    else:
        print("Wrong choice")

if __name__ == "__main__":
    main()

