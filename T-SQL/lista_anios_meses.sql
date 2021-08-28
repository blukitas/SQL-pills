SELECT anios.n, meses.n
				FROM (VALUES( 2019 ), ( 2020 )) anios(n)
					--(SELECT YEAR(FECHA_ALTA) AS anio
					--	FROM bant_vw.prestamos
					--	GROUP BY YEAR(FECHA_ALTA)
					--) AS anios  --Anios en que se dieron prestamos
				, (VALUES( 1 ), ( 2 ), ( 3 ), ( 4 ), ( 5 ), ( 6 ), ( 7 ), ( 8 ), ( 9 ), ( 10 ), ( 11 ), ( 12 )) meses(n)