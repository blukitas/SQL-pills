
SELECT 
       *
  FROM
 (
  SELECT 
         ROW_NUMBER() OVER(PARTITION BY BCFech
         ORDER BY 
                  BCFech DESC) AS r
				  , BCFech AS BCFecha
       , BCTasa AS                BCTASA
    FROM BANTOTAL..FSH012
    WHERE BCEmp = 1
          AND BCTOp = 3
          AND BCMod = 21
          AND BCMda = 80
          AND BCSdMN <> 0
 ) AS sq
  WHERE r = 1;