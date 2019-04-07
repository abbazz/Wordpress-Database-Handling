Name: Abbasali Gulabiwala
Campus ID: 017056895
Email: abbasgulabiwala@gmail.com

-> I have created stored procedures for both the sql files, and called the
procedure at the end of the file so that they can be run via command line directly.
-> The list.sql can be directly run via command line as per advised, 
however, in changePass.sql I provided the password input via parameter to the
stored procedure, in order to aptly run it via the command line.
-> It is possible to take user input of password by removing 
last line from the changePass.sql file that calls the 
stored procedure, and call it explicitly after creating the stored procedure,
using the command call changePass('desired_password'); in the command prompt.
-> Added few event handlers in both the files to handle errors gracefully.