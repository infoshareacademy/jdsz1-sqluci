### Cz�� 1
#### 1.1. Z kt�rego kraju mamy najwi�cej wniosk�w?
* W przypadku najwi�kszej ilo�ci wniosk�w (67584) nie okre�lono kraju 
* Z wniosk�w w kt�rych okre�lono kraj, najwi�cej wniosk�w (47737) pochodzi z Irlandii

##### listing zad. 1
    SELECT kod_kraju,
       count(*)
    FROM wnioski
    GROUP BY kod_kraju 
    ORDER BY 2 DESC
    LIMIT 2
![Tabela SQL zad 1](https://github.com/WojciechArtichowicz/jdsz1_wojciech_artichowicz/blob/master/SQL_ZADANIA/db_out_img/1.PNG)

#### 1.2. Z kt�rego j�zyka mamy najwi�cej wniosk�w?
Najwi�cej wniosk�w zosta�o z�o�onych w j�zyku angielskim.
##### listing zad. 2
    SELECT jezyk, count(*)
    FROM wnioski
    GROUP BY jezyk
    ORDER BY 2 DESC
    LIMIT 1
![Tabela SQL zad 2](https://github.com/WojciechArtichowicz/jdsz1_wojciech_artichowicz/blob/master/SQL_ZADANIA/db_out_img/2.PNG)

#### 1.3. Ile % procent klient�w podr�owa�o w celach biznesowych a ilu w celach prywatnych?
* 168876 klient�w = 93,4 % procent sk�adaj�cych wniosek nie poda�o typu podr�y;
* 8273 klient�w = 4,6 % podr�owa�o w celach biznesowych
* 2586 klient�w = 1,4 % podr�owa�o w celach prywatnych
##### listing zad. 3

    with tab_typ_podrozy as (
        SELECT CASE
               WHEN typ_podrozy IS NULL
                 THEN 'UNKNOWN'
               ELSE typ_podrozy
               END col_tp
        FROM wnioski
    )
    
    select col_tp typ,
           COUNT(col_tp) liczba_wnioskow,
           ROUND(count(col_tp) / SUM(COUNT(col_tp)) OVER ()::NUMERIC,4) procent_typu
    FROM tab_typ_podrozy
    GROUP BY col_tp
    ORDER BY 1;

![Tabela SQL zad 3](https://github.com/WojciechArtichowicz/jdsz1_wojciech_artichowicz/blob/master/SQL_ZADANIA/db_out_img/3.PNG)

#### 1.4. Jak procentowo rozk�adaj� si� �r�d�a polecenia?
##### listing zad. 4
    with tab_zp as (
        SELECT CASE
               WHEN zrodlo_polecenia IS NULL
                 THEN 'UNKNOWN'
               ELSE zrodlo_polecenia
               END col_zp
        FROM wnioski
    )
    
    select col_zp,
           ROUND(count(col_zp) / SUM(COUNT(col_zp)) OVER ()::NUMERIC,4) procent_typu
    from tab_zp
    Group by col_zp;
    
![Tabela SQL zad 4](https://github.com/WojciechArtichowicz/jdsz1_wojciech_artichowicz/blob/master/SQL_ZADANIA/db_out_img/4.PNG)

#### 1.5. Ile podr�y to trasy z�o�one z jednego / dw�ch / trzech / wi�cej tras?
##### listing zad. 5
    -- utworz pomocnicza tabele zawierajaca zliczone pod-trasy w rozwazanej podrozy
    -- sp.id_podrozy, p.id sa wypisane w celu kontroli poprawnosci zapytania
    with tab_pod_tr as (
    SELECT sp.id_podrozy
            ,p.id
           ,COUNT(*) col_liczba_tras
    from podroze p
    join szczegoly_podrozy sp ON p.id = sp.id_podrozy
    GROUP BY p.id, sp.id_podrozy
    ),
    -- utworz pomocnicza tabele zawierajaca zliczona liczbe podrozy w ktorych wystapila
    -- dana liczba przesiadek Np.: Zadnej przesiadki (col_distinct_liczba_tras = 1) nie bylo w
    -- trakcie 165532 podrozy*/
    tab_liczba_podrozy as(
    select col_liczba_tras col_distinct_liczba_tras, count( * ) col_liczba_podrozy
    From tab_pod_tr
    group by col_liczba_tras
    order by 1)
    
    -- posortuj powyzsze wyniki i wyswietl tylko 3 pierwsze
    (select to_char(col_liczba_tras,'99') liczba_tras, count(*) liczba_podrozy
    From tab_pod_tr
    group by col_liczba_tras
    order by 1
    limit 3)
    UNION ALL
    -- a anstepnie zsumuj reszte i doklej do wyswietlanej tabeli
    (select '>3', sum(col_liczba_podrozy)
    from tab_liczba_podrozy
    where col_distinct_liczba_tras > 3);

![Tabela SQL zad 5](https://github.com/WojciechArtichowicz/jdsz1_wojciech_artichowicz/blob/master/SQL_ZADANIA/db_out_img/5.PNG)

#### 1.6. Ile podr�y to trasy z�o�one z jednego / dw�ch / trzech / wi�cej tras?
##### listing zad. 6

    with tab_kwota_rekompensat as(
        select konto,
               sum(kwota)
        from szczegoly_rekompensat
        group by konto)
    
    (SELECT 'min' stat, *
    From tab_kwota_rekompensat
    order by 3 asc
    limit 1)    
    UNION ALL    
    (SELECT 'max' stat, *
    From tab_kwota_rekompensat
    order by 3 desc
    limit 1) ;
![Tabela SQL zad 6](https://github.com/WojciechArtichowicz/jdsz1_wojciech_artichowicz/blob/master/SQL_ZADANIA/db_out_img/6.PNG)

#### 1.7. Kt�ry dzie� jest rekordowym w firmie w kwestii utworzonych wniosk�w?
##### listing zad. 7
    SELECT to_char(w.data_utworzenia,'YYYY-MM-DD') dni, count(*)
    from wnioski w
    GROUP BY dni
    Order By 2 desc
    LIMIT 1
![Tabela SQL zad 7](https://github.com/WojciechArtichowicz/jdsz1_wojciech_artichowicz/blob/master/SQL_ZADANIA/db_out_img/7.PNG)

#### 1.8. Kt�ry dzie� jest rekordowym w firmie w kwestii otrzymanych rekompensat?
##### listing zad. 8

    SELECT to_char(r.data_zakonczenia,'YYYY-MM-DD') dni, count(*)
    FROM rekompensaty r
    GROUP BY dni
    order by 2 desc
    limit 1
   ![Tabela SQL zad 8](https://github.com/WojciechArtichowicz/jdsz1_wojciech_artichowicz/blob/master/SQL_ZADANIA/db_out_img/8.PNG)
    
#### 1.9. Jaka jest dystrubucja tygodniowa wniosk�w wed�ug kana��w? (liczba wniosk�w w danym tygodniu w ka�dym kanale)
##### listing zad. 9

    SELECT to_char(data_utworzenia,'WW') tydzien,
           kanal,
           COUNT(*)
    FROM wnioski
    group by tydzien, kanal
    
   ![Wykres dystrybucji](https://github.com/WojciechArtichowicz/jdsz1_wojciech_artichowicz/blob/master/SQL_ZADANIA/db_out_img/9b.PNG)
   ![Tabela SQL zad 9](https://github.com/WojciechArtichowicz/jdsz1_wojciech_artichowicz/blob/master/SQL_ZADANIA/db_out_img/9a.PNG)
   
#### 1.10. Lista wniosk�w przeterminowanych (przeterminowany = utworzony w naszej firmie powy�ej 3 lat od daty podr�y)
##### listing zad. 10

    SELECT  w.id,
            sp.data_wyjazdu,
            w.data_utworzenia::date,
            age(w.data_utworzenia::date, sp.data_wyjazdu) wiek_wniosku
    
    FROM szczegoly_podrozy sp
    JOIN podroze p ON p.id = sp.id_podrozy
    JOIN wnioski w ON p.id_wniosku = w.id
    where age(w.data_utworzenia::date, sp.data_wyjazdu) > '3 years'::interval
    order by 1

![Tabela SQL zad 9](https://github.com/WojciechArtichowicz/jdsz1_wojciech_artichowicz/blob/master/SQL_ZADANIA/db_out_img/10.PNG)

### Cz�� 2
#### 2.2. Jaka cz�� naszych klient�w to powracaj�ce osoby?
##### listing zad. 2.2
    -- wyszukanie klientow powracajacych, tj. takich, ktorzy zlozyli wiecej niz jeden wniosek,
    --czyli wystepuja w tabeli wiecej niz raz
    WITH tab_klienci_powracajacy AS (
    SELECT k.imie,
           k.nazwisko,
           k.email,
           COUNT(*) col_liczba_wnioskow
    FROM klienci k
    GROUP BY k.imie, k.nazwisko, k.email
    HAVING COUNT(*) > 1),
    
    --zliczenie liczby powracajacyh klientow
    tab_liczba_powracajacych_klientow AS (
    SELECT
        1 col_row_count,
        COUNT(*) col_liczba_powracajacych_klientow
    FROM tab_klienci_powracajacy
    ),
    
    --SELECT * FROM tab_liczba_powracajacych_klientow; --testing
    
    --obliczenie calkowitej liczby klient�w (z odrzuceniem powtarzaj�cych si� rekord�w)
    tab_liczba_klientow AS (
    SELECT
        1 col_row_count,
        COUNT(DISTINCT  k.email) col_liczba_klientow
    FROM klienci k)
    
    -- obliczenie procentu (cz�ci) powracaj�cych klient�w tj. jednego klienta
    -- bez uwzgl�dniania os�b bed�cych wsp�pasa�erami
    SELECT lpk.col_liczba_powracajacych_klientow liczba_powracajacych_klientow,
           lk.col_liczba_klientow liczba_wszystkich_klientow,
           ROUND(lpk.col_liczba_powracajacych_klientow / lk.col_liczba_klientow::NUMERIC,8) procent
    FROM tab_liczba_klientow lk
    JOIN tab_liczba_powracajacych_klientow lpk ON lpk.col_row_count = lk.col_row_count;

![Tabela SQL zad 2.2](https://github.com/WojciechArtichowicz/jdsz1_wojciech_artichowicz/blob/master/SQL_ZADANIA/db_out_img/2_2.PNG)

 Badanie bazy danych pod k�tem za�o�enia, �e tabela klient�w jest unikalna tzn. rekordy klient�w si� nie powtarzaj�  i klienci sa przypisani do wniosk�w (jeden klient mo�e mie� wiele wniosk�w).
##### listing zad. 2.2a
           SELECT 'liczba klientow = ' nazwa,
                  COUNT(*)
           FROM klienci
           UNION ALL
             SELECT 'liczba wnioskow = ' nazwa,
                      COUNT(*)
              FROM klienci
                  UNION ALL
                      SELECT 'klienci vs vnioski = ' nazwa,
                              COUNT(k.id)
                      FROM wnioski w
                      JOIN klienci k ON k.id_wniosku = w.id
                          UNION ALL
                              SELECT 'distinct wnioski by klienci= ' nazwa,
                              COUNT(DISTINCT w.id)
                              FROM klienci k
                              JOIN wnioski w ON k.id_wniosku = w.id
                                  UNION ALL
                                     SELECT 'distinct klienci by wnioski = ' nazwa,
                                     COUNT(DISTINCT k.id_wniosku)
                                     FROM wnioski w
                                     JOIN klienci k ON k.id_wniosku = w.id
           --liczba wnioskiw = liczba klientow = join liczba wnioskow i klientow
    
    
        SELECT k.id
               ,count(k.id)
               ,count(w.id)
        FROM wnioski w
        JOIN klienci k ON k.id_wniosku = w.id
        GROUP BY k.id
        HAVING  count(k.id) > 1 OR count(w.id)>1 --z t� instrukcj� dostaje si� 0 rekord�w, tzn k.id i w.id si� nie powtarzaj�
            UNION ALL
                SELECT w.id
                      ,count(k.id)
                      ,count(w.id)
                FROM wnioski w
                JOIN klienci k ON k.id_wniosku = w.id
                GROUP BY w.id
                HAVING  count(k.id) > 1 OR count(w.id)>1 --z t� instrukcj� dostaje si� 0 rekord�w, tzn k.id i w.id si� nie powtarzaj�
    
**WYNIK ANALIZY**: To klienci sa przypisani wnioskom. Ponadto liczba wniosk�w i liczba klient�w jest taka sama. Na ka�dy wniosek przypada   rekord w tabeli klienci. Rekrody klient�w s� (prawdopodobnie) dodawane razem z rekordami wniosk�w. W zwi�zku z tym je�li jeden klient z�o�y� kilka wniosk�w, to w tabeli klienci b�dzie wyst�powa� wielokrotnie.
*    Konieczne jest wyszukiwanie klient�w po imionach i nazwiskach. Aby unikn�� scalenia klient�w o identycznych danych
* nale�y dodac jeszcze co� co ich r�ni na pewno. Z braku unikatowego identyfikatora (np. PESEL - tu brak)
* u�yty zostanie adres e-mail.
* zatem pozostaje sprawdzi� klient�w po imieniu i nazwisku i ewentualnie adresie e-mail
* Yay!!! Pewien klient wyst�puje 618 razy. Trzeba sprawdzi� czy to nie b��d i czy podpi�te sa do niego r�ne wnioski

    -- odkomentowanie k.id_wniosku, spowoduje sprawdzenie czy jaki� (powracaj�cy) klient ma    dwa takie same wnioski:
    -- kwerenda (po odkomentowaniu) zwraca zero rekord�w wi�c ka�dy wniosek klienta jest   unikalny
    ##### listing zad. 2.2b
        select k.imie,
            k.nazwisko,
           k.email,
          --k.id_wniosku,
           count(*)
           from klienci k
           join wnioski w ON w.id = k.id_wniosku
           group by k.imie, k.nazwisko, k.email--, k.id_wniosku
           having count(*) > 1

#### 2.3. Jaka cz�� naszych wsp�pasa�er�w to osoby, kt�re ju� wcze�niej pojawi�y si� na jakim� wniosku?
##### listing zad. 2.3
    
        -- wspolpasazerowie, kt�rzy pojawili si� na innym wniosku jako wspolpasazerowie
        WITH tab_all_emails AS (
            WITH tab_multi_wspolpasazerowie AS (
                SELECT wp.email col_email,
                COUNT(wp.id_wniosku)
                FROM wspolpasazerowie wp
                GROUP BY wp.email
                HAVING COUNT(wp.id_wniosku)>1
           )
           SELECT col_email
           FROM tab_multi_wspolpasazerowie
           UNION --merge by email
           -- wspolpasazerowie, kt�rzy pojawili si� na innym wniosku jako klienci
           SELECT k.email
           FROM klienci k
           JOIN wspolpasazerowie wp ON wp.email = k.email
        ),
    
        tab_distinct_email_count as (
           SELECT
           1 col_row_number,
           COUNT(DISTINCT email)
           FROM wspolpasazerowie
        ),
    
        tab_all_emails_count as (
            SELECT
            1 col_row_number,
            COUNT(*)
            FROM tab_all_emails
        )
    
        SELECT taec.count liczba_wystapien,
               tdec.count liczba_wspolpasazerow,
               ROUND(taec.count/ tdec.count::NUMERIC,5) procent
        FROM tab_all_emails_count taec
        JOIN tab_distinct_email_count tdec ON tdec.col_row_number = taec.col_row_number;
        
![Tabela SQL zad 2.3](https://github.com/WojciechArtichowicz/jdsz1_wojciech_artichowicz/blob/master/SQL_ZADANIA/db_out_img/2_3.PNG)
#### 2.4. Jaka cz�� klient�w pojawi�a si� na innych wnioskach jako wsp�pasa�er?
##### listing zad. 2.4

    --policzenie wszystkich klientow
    --policzenie wszystkich klientow
    with tab_liczba_klientow as(
         SELECT 1 col_row_number,
         count(distinct email) col_liczba
         FROM klienci
    ),

    -- select * from tab_liczba_klientow --check

    -- wyszukanie tych samych adresow e-mail w tabeli wspolpasazerowie
    tab_jako_wspolpasazerowie AS (
         SELECT 1 col_row_number,
         COUNT(DISTINCT k.email) col_liczba
         FROM klienci k
         JOIN wspolpasazerowie w ON k.email = w.email
    )

       -- select * from tab_jako_wspolpasazerowie --check
    
       SELECT jw.col_liczba,
              lk.col_liczba,
              ROUND(jw.col_liczba/lk.col_liczba::numeric,5) procent
       FROM tab_jako_wspolpasazerowie jw
       JOIN tab_liczba_klientow lk ON jw.col_row_number = lk.col_row_number

![Tabela SQL zad 2.4](https://github.com/WojciechArtichowicz/jdsz1_wojciech_artichowicz/blob/master/SQL_ZADANIA/db_out_img/2_4.PNG)
#### 2.5. Czy jako nowy klient maj�cy kilka zak��ce�, od razu sk�adasz kilka wniosk�w? Jaki jest czas od z�o�enia pierwszego do kolejnego wniosku?

Z danych wynika, �e ka�dy z klient�w - opr�cz jednego - z�o�y� tylko po jednym wniosku. Natomiast rozwa�any klient sk�ada� po kilka wniosk�w tego samego dnia. Przy czym �rednio sk�ada� wniosek co 10 dni. Najkr�tsza przerwa mi�dzy z�o�eniem wniosk�w wynios�a 1 dzie�, natomiast najd�u�sza 338 dni.

##### listing zad. 2.5
    -- zapytanie czy klienci w og�le sk�adaj� po kilka wniosk�w jednocze�nie
        --zliczenie liczby wniosk�w sk�adanych jednocze�nie
        --posortowanie ich rosn�co wzgl�dem emaili i czasu z�o�enia wniosku
        WITH tab_liczba_jednoczesnych_wnioskow_per_klient AS (
            SELECT k.email col_email,
                to_char(w.data_utworzenia,'YYYY-MM-DD') col_day,
                COUNT(w.id) col_liczba
             FROM klienci k
             JOIN wnioski w ON k.id_wniosku = w.id
             GROUP BY col_email, col_day
             ORDER BY col_email, col_day
        ),
    
        --SELECT * FROM tab_liczba_jednoczesnych_wnioskow_per_klient WHERE col_liczba >1 --check
        tab_interval_miedzy_wnioskami_per_klient AS (
        SELECT col_email col_email,
               to_date(col_day,'YYYY MM DD')-to_date(LAG(col_day) OVER (ORDER BY col_day),'YYYY MM DD') col_roznica,
               LAG(col_email) OVER (ORDER BY col_email) lag_email
        FROM tab_liczba_jednoczesnych_wnioskow_per_klient --check
        WHERE col_liczba > 1
       )
    
    
       SELECT col_email,
              MIN(col_roznica),
              ROUND(AVG(col_roznica),3) srednia_liczba_dni,
              MAX(col_roznica)
       FROM tab_interval_miedzy_wnioskami_per_klient
       WHERE col_email = lag_email
       GROUP BY col_email
![Tabela SQL zad 2.4](https://github.com/WojciechArtichowicz/jdsz1_wojciech_artichowicz/blob/master/SQL_ZADANIA/db_out_img/2_5.PNG)
> Written with [StackEdit](https://stackedit.io/).
