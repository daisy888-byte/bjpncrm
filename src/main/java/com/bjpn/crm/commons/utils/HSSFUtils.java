package com.bjpn.crm.commons.utils;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.ss.usermodel.CellType;

public class HSSFUtils {
    public static String cell2String(HSSFCell cell){
        String value="";
        if(cell.getCellType()== HSSFCell.CELL_TYPE_STRING){
            value=cell.getStringCellValue();
        }else if(cell.getCellType()== HSSFCell.CELL_TYPE_NUMERIC){
            value=(int)cell.getNumericCellValue()+"";
        }else if(cell.getCellType()== HSSFCell.CELL_TYPE_FORMULA){
            value=cell.getCellFormula();

        }else  if(cell.getCellType()== HSSFCell.CELL_TYPE_BOOLEAN){
            value=cell.getBooleanCellValue()+"";
        }
        else{
            value="";
        }
        return value;
    }
}
