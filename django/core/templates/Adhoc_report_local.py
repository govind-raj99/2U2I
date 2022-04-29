from xlsxwriter import Workbook
import pandas as pd
import io
from datetime import datetime
import numpy as np

df = pd.read_excel('Toll Free Fake Data1yr04.xlsx')

user_data = df[['tollfree','caller','call_date','dduration','cost']].sort_values(by='dduration',ascending=False)

options = {'default_date_format': 'dd/mm/yy', 
           'remove_timezone': True,
           'in_memory': True} # in_memory to set true to disable writing temp file.

with Workbook('Short Calls.xlsx',options) as file:
    # text and formating
    bold_blue_16 = file.add_format({'bold':True, 'font_color':'blue','font_size':16}) # for color can also use rgb codes eg darkblue '#000066'
    normal_bold = file.add_format({'bold':True})
    normal_text = file.add_format({'bold':False})
    coloured_cell_bold = file.add_format({'bold':True,'bg_color':'blue','font_color':'white','bottom':2})
    blue_color = file.add_format({'bold':True,'bg_color':'#0072ce','font_color':'white'})
    date_format = file.add_format({'num_format': 'dddd, mmmm dd, yyyy'})
    # create sheet
    worksheet = file.add_worksheet() # can also specify name for sheet # Workbook.add_worksheet('Top 5 call')
    # g column for infos cause nice if print a4 just fit a4 size
    # all writing data operation is done on worksheet
#     worksheet.merge_range(
#         'A1:C5',
#         'Merged Cells'
#     )
    image_options = {
        'x_scale':0.7,
        'y_scale':0.7,
        "object_position":1,
        #"url":'http://example.com', # make image clickable to open webpage
        'decorative':False
    }
    #worksheet.insert_image('A2','TM Logo.png',image_options)
    worksheet.write_datetime('E2', datetime.today(), date_format)
    worksheet.write_string('E3','User_Name',normal_bold)
    worksheet.write_string('E4','1300-88-XXXX',normal_bold)
    worksheet.write_string('E5','27 Aug 2022 to 29 Aug 2022',normal_bold)
    worksheet.write_string('E6','Short Calls',normal_text)
    
    # set column widht
    # worksheet.set_column('f:G',30) # width in char units (bilangan huruf)
    
    # write column names
    for i, col in enumerate(user_data):
        worksheet.set_column(i,i,15)
        worksheet.write_string(7,i, col, blue_color) # row,column,data, format
        for j, item in enumerate(user_data[col]):
            if col == 'dduration':
                worksheet.write_string(8+j,i,str(item))
            else:
                worksheet.write(8+j,i,item) # row,column,data,format