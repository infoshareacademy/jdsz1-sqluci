# Raport cząstkowy
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

Wynik wykonania zapytania przedstawiono na Rys. 1.

![Tabela]( https://github.com/infoshareacademy/jdsz1-sqluci/blob/master/PROJEKT/WOJTEK/potencjalOperatorow.PNG )

Rys. 1. Wynik zapytania z Listingu 3.1.1.

#### 3.2. Wyniki analizy (szczegółowe)
Tabele oraz odpowiadajace im wykresy przedstawiające dystrybucję liczby tras (Tab. 1, Rys. 3.2.1),
sumy rekompensaty (Tab. 2, Rys. 3.2.2) oraz średnią rekompensatę względem operatorów (Tab. 3, Rys. 3.2.3) 
znajdują się poniżej.

# Tab. 1. Liczba tras z podziałem na operatorów i kod przyjazdu
![Liczba tras z podziałem na operatorów i kod przyjazdu]( https://github.com/infoshareacademy/jdsz1-sqluci/blob/master/PROJEKT/WOJTEK/Tab1.png )

![Liczba tras opóźnionych / odwołanych względem operatorów]( https://github.com/infoshareacademy/jdsz1-sqluci/blob/master/PROJEKT/WOJTEK/Rys1.png )
Rys. 3.2.1.  Liczba tras opóźnionych i odwołanych z podziałem na operatorów i kod przyjazdu

# Tab. 2. Kwota rekompensaty z podziałem na operatorów i kod przyjazdu
![Kwota rekompensaty z podziałem na operatorów i kod przyjazdu]( https://github.com/infoshareacademy/jdsz1-sqluci/blob/master/PROJEKT/WOJTEK/Tab2.png )

![Kwota rekompensaty opóźnionych / odwołanych względem operatorów]( https://github.com/infoshareacademy/jdsz1-sqluci/blob/master/PROJEKT/WOJTEK/Rys2.png )
Rys. 3.2.2.  Kwota rekompensaty tras opóźnionych i odwołanych z podziałem na operatorów i kod przyjazdu

# Tab. 3. Średnia kwota rekompensaty z podziałem na operatorów i kod przyjazdu
![śrenia kwota rekompensaty z podziałem na operatorów i kod przyjazdu]( https://github.com/infoshareacademy/jdsz1-sqluci/blob/master/PROJEKT/WOJTEK/Tab3.png )

![Śrenia kwota rekompensaty opóźnionych / odwołanych względem operatorów]( https://github.com/infoshareacademy/jdsz1-sqluci/blob/master/PROJEKT/WOJTEK/Rys3.png )
Rys. 3.2.3.  Średnia kwota rekompensaty tras opóźnionych i odwołanych z podziałem na operatorów i kod przyjazdu

Z przedstawionych danych zagregowanych wynika, że największa liczbe tras z potencjałem rekompensaty zrealizował 
operator EiC. Trasy:
 - odwołane  52,1 tys tras z całkowita kwotą rekompensaty 15,41 mln PLN (waluta - założono polskie złote). 
 - opóźnione 22 tys tras z całkowita kwotą rekompensaty 8,47 mln PLN.

Są to wartości dwukrotnie wyższe w stosunku do odpowiadających wartości innych przewoźników. Średnia liczba tras
(nie uwzględniająca EiC) 
 - odwołanych 26 tys (średnia całkowita kwota rekompensaty 7,70 mln PLN).
 - opóźnioncyh 11 tys (średnia całkowita kwota rekompensaty 4,24 mln PLN).
 
 Poza przewoźnikiem EiC liczba tras odwołanych lub odpowiednio opóźnionych oraz sum wynikających z nich rekompensat 
 nie różnią się istotne od średniej.
 
 Średnie kwoty rekompensaty wśród tras odwołanych i opóźnionych względem przewoźników nie różnią się istotnie.
 Średnia rekompensata za kurs opóźniony jest wyższa od rekompensaty za kurs odwołany o 90 PLN.
 
 #### 3.3. Wyniki analizy (podsumowanie)
 
 **Największy potencjał względem rekompensat ma przewoźnik EiC.**
 * W celu uzyskania pełniejszego obrazu sytuacji należy poddać analizie także
   - koszt uzyskania rekompensaty
   - czas oczekiwania na rozstrzygnięcie sprawy
 