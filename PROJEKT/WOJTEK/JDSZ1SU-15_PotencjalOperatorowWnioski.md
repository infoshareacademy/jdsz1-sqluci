# Raport
## [JDSZ1SU-15] Potencjał operatorów
### 1. Cel analizy
Celem analizy jest okreslenie potencjału operatorów połączeń kolejowych pod względem możliwości uzyskania rekompensat za połączenia odwołane lub opóźnione.
### 2. Wstępna analiza danych
#### 2.1. Opis danych
System zarzadzania baza danych: **SZBD PostgreSQL**.

Dane wymagane do przeprowadzenia analizy znajdują się w dwóch tabelach : 
**o_trasy** oraz **o_operatorzy**.  Tabela **o_trasy** liczy **337101** rekordów 
zawierających dane na temat zrealizowanych tras. Z punktu przeprowadzonej analizy 
istotne są następujące pola tabeli: 
 - kod_polaczenia - zawiera unikalny kod zrealizowanego połączenia;
 - przylot_status - zawiera informację na temat statusu przyjazdu 
 (opóźniony / odwołany / o czasie itp.);
 -  rekompensata - zawiera kwotę możliwej do uzyskania rekompensaty;
 - czy_uprawniony - zawiera informacje czy rekompensata jest uprawniona.
 

 
 #### 2.2. Poprawność danych
 Dane sprawdzono pod kątem poprawności:
  - scalono rekordy powtarzające się;
  - scalono rekordy o identycznych wartościach **kod_połączenia**. Kod połączenia powinien być
  wartością unikatową. W przypadku powtarzającego się kodu połączenia wskazana jest analiza
  różnic rekordów. Do dalszej analizy wybrano pierwszy rekord o danym kodzie połączenia i 
  odrzucono kolejne. Rezultat ten otrzymano stosując instrukcję `SELECT DISTINCT ON`.
  - odrzucono rekordy o niespójnych danych: 
      * kod wyjazdu = odwołany, kod przyjazdu != odwołany,
      * kod wyjazdu != odwołany, kod przyjazdu = odwołany.
  - **do analizy potencjału wykorzystano tylko trasy oznaczone jako uprawnione do rekompensaty.**
  
  ### 3. Analiza potencjału
  #### 3.1. Szczegóły analizy
  
  **Analizę potencjału operatorów** przeprowadzono pod względem **liczby tras** zrealizowanych przez danego operatora kolejowego,
  **całkowitej sumy rekompensaty** oraz **średniej wartości rekompensaty**. Dane pogrupowano względem
  operatorów tras oraz typu przyjazdu. Z punktu widzenia zadania istotne są tylko
  połączenia z kodem przyjazdu oznaczonym jako opóźniony lub odwołany, gdyż jedynie w takich
  przypadkach możliwe jest otrzymanie rekompensaty.  Kod użyty w zapytaniu bazy danych
  przedstawiono poniżej (*Listing. 3.1.1*).
  
  **Listing. 3.1.1**
  ```postgresplsql
    WITH tab_o_trasy_clean AS ( --wybranie unikalnych rekordów w ogóle
    SELECT DISTINCT *
    FROM ( --wybranie unikalnych rekordów względem kodu połączenia
          SELECT DISTINCT ON (kod_polaczenia) *
          FROM o_trasy
    ) tab_o_trasy_pre_clean
    WHERE NOT (
               (wylot_status = 'CX' AND przylot_status != 'CX')
                OR (wylot_status != 'CX' AND przylot_status = 'CX')
              )
)

SELECT o.nazwa,

       CASE
          WHEN tc.przylot_status IN ('EY','OT','CX','DY','NS') THEN  tc.przylot_status
          ELSE 'UN'
        END,
       COUNT(*) liczba_tras,
       SUM(tc.rekompensata) suma_rekompensaty,
       ROUND(AVG(tc.rekompensata),1) sr_rekompensata
FROM tab_o_trasy_clean tc
JOIN o_operatorzy o ON o.kod = tc.kod_operatora
WHERE tc.czy_uprawniony = TRUE
GROUP BY 1, 2
ORDER BY 1, 2;
``` 

#### 3.2. Wnioski