from create_table_fpdf2 import PDF
#from fpdf import FPDF
import sqlite3
import xlrd
 
conn = sqlite3.connect('db.sqlite3')
print('Connected to database successfully.')
 
cur = conn.cursor()
cur.execute("select * from authentication_tollfree")
 
#only print head
title = [i[0] for i in cur.description]
print(title)

rows = cur.fetchall()
for row in rows:
   print("ID: "+str(row[0])+"     Start DateTime: "+row[1]+"     TollFree: "+row[2])
#   print("")

pdf = PDF()
pdf.add_page()

page_width = pdf.w - 2 * pdf.l_margin

pdf.set_font('Times','B',14.0) 
pdf.cell(page_width, 0.0, 'TollFree Data', align='C')
pdf.ln(10)

pdf.set_font('Courier', '', 12)

col_width = page_width/6

pdf.ln(1)

th = pdf.font_size

#Header
#pdf.cell(col_width, th, "Start DateTime", border=1)
pdf.cell(col_width, th, "TollFree", border=1)
pdf.cell(col_width, th, "AnswerPoint", border=1)
#pdf.cell(col_width, th, "Customer Name", border=1)
pdf.cell(col_width, th, "Account Num", border=1)
pdf.cell(col_width, th, "Caller", border=1)
pdf.cell(col_width, th, "Duration", border=1)
pdf.cell(col_width, th, "Cost", border=1)
pdf.ln(th)

#Data
for row in rows:
   pdf.cell(col_width, th, str(row[1]), border=1)
   pdf.cell(col_width, th, row[2], border=1)
 #  pdf.cell(col_width, th, row[3], border=1)
   pdf.cell(col_width, th, row[4], border=1)
   pdf.cell(col_width, th, row[5], border=1)
   pdf.cell(col_width, th, row[6], border=1)
   pdf.cell(col_width, th, row[16], border=1)
 #  pdf.cell(col_width, th, row[18], border=1)
   pdf.ln(th)

pdf.ln(10)

pdf.set_font('Times','',10.0) 
pdf.cell(page_width, 0.0, '- end of report -', align='C')

#pdf.create_table(table_data = cur,title='I\'m the first title', cell_width='even')
pdf.ln()
pdf.output('test01.pdf') 
conn.close()


#Read EXCEL file xls type
loc = ("testdata.xls")
# To open Workbook
wb = xlrd.open_workbook(loc)
sheet = wb.sheet_by_index(0)
 
# For row 0 and column 0
print(sheet.cell_value(0, 0))

for i in range(sheet.nrows):
  #print(sheet.cell_value(0, i))
  print(i )
  print(sheet.row_values(i))
