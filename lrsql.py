"""
    O arquivo de análises tem o formato:
    ID_ANALISE$%#NOME_ANALISE$%#OWNER$%#MODIFIEDBY$%#MODIFIEDON$%#CREATEDON$%#TIPO$%#TXDATA
"""
import os
import sys

DEBUG = False
COLUMNS = ["idanalysis", "nameanalysis", "owner", "modifiedby", "modifiedon", "dtcreation", "type", "txdata"]
TYPENULL = "PARTICULAR"
FILECHAR = ["_", "\\", "/", "*", ":", "?", "\"", ">", "<", "|"]
PARENTDIR = "./"

def separete():
    with open(file="todas_analises.txt", mode="rt", encoding="utf-8") as infile:
        texto = infile.readlines()
        
        nameoutfile = ""
        if DEBUG: print(texto[0])

        for line in texto[1:]:
            strstart = 0
            strindex = 0
            if "$%#" in line:
                strindex = line.index("$%#", strstart)
                idanalysis = line[strstart:strindex]
                if DEBUG: print(strindex, idanalysis)

                strstart = strindex +3
                strindex = line.index("$%#", strstart)
                nameanalysis = line[strstart:strindex]
                if DEBUG: print(strindex, nameanalysis)

                strstart = strindex +3
                strindex = line.index("$%#", strstart)
                owner = line[strstart:strindex]
                if DEBUG: print(strindex, owner)

                strstart = strindex +3
                strindex = line.index("$%#", strstart)
                modifiedby = line[strstart:strindex]
                if DEBUG: print(strindex, modifiedby)

                strstart = strindex +3
                strindex = line.index("$%#", strstart)
                dtcreation = line[strstart:strindex]
                if DEBUG: print(strindex, dtcreation)

                strstart = strindex +3
                strindex = line.index("$%#", strstart)
                modifiedon = line[strstart:strindex]
                if DEBUG: print(strindex, modifiedon)

                strstart = strindex +3
                strindex = line.index("$%#", strstart)
                antype = line[strstart:strindex]
                if DEBUG: print(strindex, antype)

                strstart = strindex +3
                #strindex = line.index("$%#", strstart)
                txdata = line[strstart:]
                if DEBUG: print(strindex, txdata)

                for ch in FILECHAR[1:]:
                    nameanalysis = nameanalysis.replace(ch,FILECHAR[0])
                    idanalysis = idanalysis.replace(ch,FILECHAR[0])
                nameoutfile = antype.replace("(null)", TYPENULL) + ' - ' + idanalysis + ' - ' + nameanalysis + '.sql'
                if DEBUG: print(nameoutfile)

            if not os.path.exists(antype.replace("(null)", TYPENULL)):
                os.mkdir(antype.replace("(null)", TYPENULL))
            os.chdir(antype.replace("(null)", TYPENULL))

            with open(file=nameoutfile, mode="at", encoding="utf-8") as outfile:
                outfile.writelines(line[strstart:])

            os.chdir("..")

def changesquote():
    subdirs = os.listdir("./")
    for subdir in subdirs:
        if os.path.isdir(os.path.join("./", subdir)):
            if DEBUG: print(subdir)
            os.chdir(subdir)

            files = os.listdir("./")
            for file in files:
                strstart = 0
                strindex = 0
                if os.path.isfile(os.path.join("./", file)):
                    if DEBUG: print(file)
                    
                    strstart = file.index(" - ") + 3
                    strindex = file[strstart:].index(" - ") + strstart
                    idanalysis = file[strstart:strindex]
                    if DEBUG: print(idanalysis)

                    with open(file=file, mode="r+t") as fin:
                        txdata = fin.read()
                        fin.seek(0)
                        txdata = txdata.replace("\'", "\' + chr(39) + \'")
                        txdatasql = f"""update database set txdata = '{txdata}' where idanalysis = '{idanalysis}'"""
                        fin.write(txdatasql)

        os.chdir("..")

    os.chdir("..")


if __name__ == '__main__':
    os.chdir(PARENTDIR)
    if 'separar' in sys.argv:
        separete()
    elif 'trocaaspas' in sys.argv:
        changesquote()
    else:
        print("Escolhe uma opção: separar ou trocaaspas")

    os.chdir("..")
