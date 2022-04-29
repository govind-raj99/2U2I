#!/usr/bin/env python
# coding: utf-8



import pandas as pd
import io
from xlsxwriter import Workbook
from sqlalchemy import create_engine
from datetime import datetime




POSTGRES_ADDRESS  = '172.20.195.13'  #'db.panoply.io' ## INSERT YOUR DB ADDRESS IF IT'S NOT ON PANOPLY
POSTGRES_PORT     = '5432'
POSTGRES_USERNAME = 'tableau'        #'username' ## CHANGE THIS TO YOUR PANOPLY/POSTGRES USERNAME
POSTGRES_PASSWORD = 'qwert123'       #'***' ## CHANGE THIS TO YOUR PANOPLY/POSTGRES PASSWORD 
POSTGRES_DBNAME   = 'tollfreedb'     # CHANGE THIS TO YOUR DATABASE NAME
# A long string that contains the necessary Postgres login information
postgres_str = ('postgresql://{username}:{password}@{ipaddress}:{port}/{dbname}'
                .format(username=POSTGRES_USERNAME,
                        password=POSTGRES_PASSWORD,
                        ipaddress=POSTGRES_ADDRESS,
                        port=POSTGRES_PORT,
                        dbname=POSTGRES_DBNAME))
# Create the connection
cnx = create_engine(postgres_str)




def exportdata(table_type, tollfree, startdate, enddate, username):
    queryEAS = f'''Select tollfree, 
            state, 
            area, 
            complete,
            duration, 
            'cost',
            busy,
            no_answer,
            other,
            incomplete
            From callsummary as c 
            where c.tollfree = {tollfree} and c.call_date >= {startdate} and c.call_date <= {enddate};
            '''
    
    output = io.BytesIO()
    
    ###################### EXCHANGE AREA SUMMARY-OVERALL ########################
    if table_type == 'EAS':
        df = pd.read_sql_query(queryEAS, cnx)
        dataEAS = df.groupby(['state','area']).agg(
        Complete_Calls = pd.NamedAgg(column='complete',aggfunc=sum),
        Total_Call_Duration = pd.NamedAgg(column='duration',aggfunc=sum),
        Total_Cost_of_Calls = pd.NamedAgg(column='cost',aggfunc=sum),
        Busy_Calls = pd.NamedAgg(column='busy',aggfunc=sum),
        No_Answer = pd.NamedAgg(column='no_answer',aggfunc=sum),
        Other = pd.NamedAgg(column='other',aggfunc=sum),
        Total_Incomplete = pd.NamedAgg(column='incomplete',aggfunc=sum),
        ).reset_index()

        dataEAS['%_Incomplete'] = (dataEAS['Total_Incomplete']/(dataEAS['Complete_Calls'] + dataEAS['Total_Incomplete']))* 100
        dataEAS['%_Incomplete'] = dataEAS['%_Incomplete'].round(2)

        dataEAS['Ave_Call_Length'] = dataEAS['Total_Call_Duration']/dataEAS['Complete_Calls']

        dataEAS['Average_Call_Length'] = pd.to_datetime(dataEAS['Ave_Call_Length'], unit='s')
        dataEAS['Average_Call_Length'] = dataEAS['Average_Call_Length'].dt.strftime('%H:%M:%S')
        dataEAS['Call_Duration'] = pd.to_datetime(dataEAS['Total_Call_Duration'], unit='s')
        dataEAS['Call_Duration'] = dataEAS['Call_Duration'].dt.strftime('%H:%M:%S')


        data = dataEAS[['state','area','Complete_Calls','Call_Duration','Average_Call_Length',
                          'Total_Cost_of_Calls','Busy_Calls','No_Answer','Other','Total_Incomplete','%_Incomplete']]
        
        data.rename({'state':'State', 'area':'Exchange Areas', 'Complete_Calls':'Calls', 'Call_Duration':'Duration', 
            'Average_Call_Length':'Avg Duration', 'Total_Cost_of_Calls':'Costs', 'Busy_Calls':'Busy', 
            'No_Answer':'No Answer', 'Total_Incomplete':'Incomplete','%_Incomplete':'Incomplete Percentage'},
            inplace=True)

    elif table_type == 'xxx':
        pass
    
    
    
    options = {'default_date_format': 'dd/mm/yy', 
               'remove_timezone': True,
               'in_memory': True} # in_memory to set true to disable writing temp file.

    
    file = Workbook(output,options)
    # text and formating
    bold_blue_16 = file.add_format({'bold':True, 'font_color':'blue','font_size':16}) # for color can also use rgb codes eg darkblue '#000066'
    normal_bold = file.add_format({'bold':True})
    normal_text = file.add_format({'bold':False})
    coloured_cell_bold = file.add_format({'bold':True,'bg_color':'blue','font_color':'white','bottom':1})
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
    end_column = len(data.columns) - 1
    worksheet.insert_image('A2','TM Logo.png',image_options)
    worksheet.write_datetime(2, end_column, datetime.today(), date_format)
    worksheet.write_string(3, end_column, 'Test User', normal_bold)
    worksheet.write_string(4, end_column, tollfree,normal_bold)
    worksheet.write_string(5, end_column, startdate +' to '+ enddate, normal_bold)
    worksheet.write_string(6, end_column, table_type ,normal_text)

    # set column widht
    #     worksheet.set_column('G:G',30) # widht in char units (bilangan huruf)

    # write column names
    for i, col in enumerate(data):
        worksheet.set_column(i,i,15)
        worksheet.write_string(7,i, col, blue_color) # row,column,data, format
        for j, item in enumerate(data[col]):
            if col == 'dduration':
                worksheet.write_string(8+j,i,str(item))
            else:
                worksheet.write(8+j,i,item) # row,column,data,format
    worksheet.set_column(end_column,end_column,len(startdate +' to '+ enddate))

    # close to save
    file.close()

    output.seek(0)
    
    # django response
    self.send_response(200)
    self.send_header('Content-Disposition', 'attachment; filename=test.xlsx')
    self.send_header('Content-type',
                     'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')
    self.end_headers()
    self.wfile.write(output.read())
    return






