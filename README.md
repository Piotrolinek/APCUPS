# APCUPS Monitor - Instrukcja
1. Instalacja systemu (ok 15 minut)
    1.1 https://www.raspberrypi.com/software/
    1.2 System operacyjny: Raspberry Pi OS (other) -> Raspberry Pi OS Lite (32-bit)
    1.3 Konfiguracja systemu:
        1.3.1 Hostname: dowolny (instrukcja zakłada "cti" za domyślną wartość)
        1.3.2 Login i hasło: głównie do połączenia przez SSH, np. cti; cti
        1.3.3 Sieć wifi: rasp1 nie posiada wbudowanego modułu wifi więc wypełnienie jest opcjonalne
        1.3.4 Usługi: Włącz SSH uwierzytelniane hasłem
3. Pierwsze uruchomienie systemu
	2.1 Zmiana rozkładu klawiatury z UK na US. Graficzny poradnik: https://linuxconfig.org/how-to-change-keyboard-layout-on-raspberry-pi
		2.1.1 sudo raspi-config
		2.1.2 (5) Localisation Options
		2.1.3 (L3) Keyboard
		2.1.4 Model klawiatury. Rekomendowany jest Generic-105 key, chyba że używana klawiatura ma niestandardowy rozkład
		2.1.5 Other
		2.1.6 English (US)
		2.1.7 English (US) (pierwsza opcja)
		2.1.8 The default for the keyboard layout
		2.1.9 No compose key
		2.1.10 Po naciśnięciu enter w tym momencie trzeba odczekać ok. 2 minut na skonfigurowanie klawiatury
		2.1.11 Finish
	2.2 Połączenie się z internetem: Wsunięcie kabla Ethernet lub konfiguracja połączenia z wifi https://www.makeuseof.com/connect-to-wifi-with-nmcli/
		2.2.1 W przypadku konfiguracji wifi, należy użyć jakiegoś odbiornika wifi na USB.
		2.2.2 Po wsunięciu do portu, weryfikacja: "nmcli dev status". Pojawi się lista urządzeń. Zazwyczaj jest to wlan0
		2.2.3 Jeżeli nie pojawiło się urządzenie należy wykonać "nmcli radio wifi on"
		2.2.4 Sprawdzenie listy wifi: "nmcli dev wifi list" 
		2.2.5 Połączenie: "sudo nmcli dev wifi connect wybrany_SSID_do_wypelnienia password "haslo_do_wypelnienia"
		2.2.6 Alternatywnie "sudo nmcli --ask dev wifi connect wybrany_SSID_do_wypelnienia" i podanie hasla ukrytego
		2.2.7 Weryfikacja połączenia w dowolny sposób, np. ping google.com
4. Połączenie SSH (opcjonalne):
	3.1 Np. przy użyciu PuTTy, łączymy po ip, (hostname -I), port 22, login oraz hasło takie jakie zostało podane przy instalacji systemu
5. Aktualizacja systemu (rekomendowane):
	4.1 Wykonanie polecenia "sudo apt update; sudo apt upgrade -y" UWAGA: w zależności od szybkości połączenia to polecenie może się wykonywać nawet do 2 godzin!
6. Git
	5.1 "sudo apt install git"
	5.2 "git clone https://github.com/Piotrolinek/APCUPS.git" - repozytorium jest publiczne by ominąć problem logowania w konsoli (od 2021 roku wymagane jest generowanie tymczasowych kluczy dostępowych).
7. Instalacja serwera nginx
	6.1 "sudo apt install nginx"
	6.2 Weryfikacja działania usługi systemowej: "systemctl status nginx"
	6.3 Jeżeli z jakiegoś powodu jest stan disabled lub konfiguracja zachowawcza nie jest ustawiona należy ustawić: "systemctl enable nginx; systemctl start nginx"
	6.4 Weryfikacja strony podstawowej, czyli na innym komputerze w tej samej sieci lokalnej, w przeglądarce należy wpisać adres ip raspberry (hostname -I), powinien pojawić się podstawowy plik serwera nginx: "Welcome to nginx! If you see this page, the nginx web server is successfully installed and working. Further configuration is required. [...]"
	6.5 Usunięcie postawowej strony (zostanie ona zastąpiona przygotowaną przez nas) "rm /var/www/html/index.nginx-debian.html"
8. Instalacja pakietu apcupsd:
	7.1 "sudo apt install apcupsd -y"
	7.2 Testowanie działania: "systemctl status apcupsd"
	7.3 Konfiguracja połączenia: "nano /etc/apcupsd/apcupsd.conf"
		7.3.1 Wartość "UPSCABLE usb" (domyślnie)
		7.3.2 Wartość "UPSTYPE usb" (domyślnie)
		7.3.3 Wartość "DEVICE" (należy usunąć wartość domyślną i pozostawić jedynie DEVICE)
	7.4 Po ustawieniu tych wartości należy ustawić flagę "ISCONFIGURED=yes" w pliku "/etc/default/apcupsd"
	7.5 Wykonanie testu połączenia: 
		7.5.1 By móc wykonać test usługa apcupsd musi być zatrzymana: "sudo systemctl stop apcupsd"
		7.5.2 "apctest"
		7.5.3 Można wybrać spośród opcji testowania urządzenia lub wyjść (q)
	7.6 Uruchomienie usługi "sudo systemctl enable apcupsd; sudo systemctl start apcupsd"
	7.7 Sprawdzenie statusu: "apcaccess status"
		7.7.1 "STATUS: COMMLOST" oznacza, że połączenie nie powiodło się. Jest to normalne za pierwszym razem i należy zrestartować system ("reboot"). Jeżeli po restarcie nadal STATUS: COMMLOST, oznacza że pewien krok instrukcji został wykonany niepoprawnie lub został pominięty. 
	7.8 Dalsza konfiguracja zostaje defaultowa. https://wiki.debian.org/apcupsd
9. Przenoszenie plików w odpowiednie miejsca z repozytorium:
	8.1 "cd /sciezka/do/APCUPS"
	8.2 "mv ./index.html /var/www/html/"
	8.3 "mv ./json_script.service /etc/systemd/system/"
	8.4 "mv ./json_script.timer  /etc/systemd/system/"
	8.5 Nadanie prawa wykonywania dla skryptu "chmod +x ./json_script.sh"
	8.6 Modyfikacja ścieżki do skryptu "nano /etc/systemd/system/json_script.service". domyślnie jest to wartość "/home/cti/APCUPS/json_script.sh"
	8.7 Aktywacja usług: "sudo systemctl enable json_script.timer; sudo systemctl start json_script.timer"
10. Wysyłanie maili
	9.1 Cała funkcjonalność jest opcjonalna (ale rekomendowana)
	9.2 Plik konfiguracyjny: "sender_config.ini"
		9.2.1 W przypadku utraty tego pliku wystarczy uruchomić skrypt "config_writer.py"
		9.2.2 Sekcja "REQUIRED" jest wymagana do pracy i musi zostać wypełniona (brak jakiegokolwiek pola spowoduje wystąpienie wyjątku)
			9.2.2.1 sender_address - Adres poczty "automatycznego wysyłacza" (o tym w sekcji dalszej - 11.Tworzenie poczty Google)
			9.2.2.2 receiver_address - Adres poczty odbiorcy
			9.2.2.3 sender_application_password - Wygenerowane hasło aplikacji "automatycznego wysyłacza" (o tym w sekcji dalszej - 11.Tworzenie poczty Google)
		9.2.3 Sekcja "DEFAULT" zawiera pola wypełnione wartościami podstawowymi, dokładniej:
			9.2.3.1 send_onbatt - Wartość bool (True/False) - Czy wysyłać wiadomość mailem gdy UPS przechodzi w stan pracy na baterii - domyślnie True - wysyłaj
			9.2.3.1 send_offbatt - Wartość bool (True/False) - Czy wysyłać wiadomość mailem gdy UPS przechodzi w stan pracy zasilania z sieci - domyślnie True - wysyłaj
			9.2.3.1 subject_onbatt - Temat maila gdy UPS przechodzi w stan pracy na baterii
			9.2.3.1 subject_offbatt - Temat maila gdy UPS przechodzi w stan pracy zasilania z sieci
			9.2.3.1 body_onbatt - Ciało maila gdy UPS przechodzi w stan pracy na baterii
			9.2.3.1 body_offbatt - Ciało maila gdy UPS przechodzi w stan pracy zasilania z sieci
	9.3 Wymagane modyfikacje plików: (UWAGA! należy zwracać uwagę na lokalizację pliku sender.py, podano domyślną ścieżkę "/home/cti/APCUPS/sender.py")
		9.3.1 "nano /etc/apcupsd/onbattery" zaraz po komentarzu należy wkleić: "python /home/cti/APCUPS/sender.py --onbatt"
		9.3.2 "nano /etc/apcupsd/offbattery" zaraz po komentarzu należy wkleić: "python /home/cti/APCUPS/sender.py --offbatt"
		9.3.3 "nano /home/cti/APCUPS/sender.py" linia 9, należy zmodyfikować ścieżkę do pliku konfiguracyjnego jeżeli nie jest ona domyślna ("/home/cti/APCUPS/sender_config.ini")
11. Nadanie praw wykonywania:
	10.1 Będąc w katalogu repozytorium (APCUPS) należy nadać uprawnienia wykonywania wszystkim plikom .sh i .py:
		10.1.1 "chmod +x ./config_writer.py"
		10.1.2 "chmod +x ./json_script.sh"
		10.1.3 "chmod +x ./sender.py"
12. Tworzenie poczty Google
	11.1 Serwer SMTP Google pozwala na wysłanie do 200 maili dziennie i przede wszystkim - jest darmowy. Poszukiwaliśmy alternatywy przez kilka godzin bez skutku, więc pozostajemy przy dosyć niewygodnym serwisie Google.
	11.2 Adres jak i hasło jest zupełnie dowolne, zakładanie poczty jest wystarczająco intuicyjne by pominąć tą część poradnika.
	11.3 Po założeniu poczty musi zostać założone 2FA (Uwierzytelnianie dwuskładnikowe) przy użyciu numeru telefonu.
	11.4 Następnie należy udać się do zarządzania kontem Google ->  ->  ->  -> 
		11.4.1 Przeszukaj konto Google: "Hasła do aplikacji"
		11.4.2 Uwierzytelniamy hasłem
		11.4.3 Generujemy hasło do aplikacji (sama nazwa aplikacji nie ma znaczenia i może być dowolna)
		11.4.4 Otrzymujemy hasło do aplikacji w formie "xxxx xxxx xxxx xxxx"
		11.4.5 To hasło wklejamy do pliku konfiguracyjnego "sender_config.ini", pole "sender_application_password"
13. Ngrok
	12.1 Założenie konta na stronie https://ngrok.com/ (jest opcja logowania przy użyciu konta Google)
	12.2 Po zalogowaniu, na panelu z lewej strony, sekcja Getting Started -> Your Authtoken - jest to token uwierzytelniania. Zostanie on użyty za chwilę, jeżeli z jakiegoś względu go nie ma, należy go wygenerować.
	12.3 Pobranie pakietu (komenda pochodzi z oficjalnej strony https://ngrok.com/download):
		12.3.1 "curl -sSL https://ngrok-agent.s3.amazonaws.com/ngrok.asc | sudo tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null && echo "deb https://ngrok-agent.s3.amazonaws.com buster main" | sudo tee /etc/apt/sources.list.d/ngrok.list && sudo apt update && sudo apt install ngrok"
	12.4 Wstawienie tokenu z punktu 12.2 "ngrok config add-authtoken <wygenerowany_authtoken>"
	12.5 Ekspozycja serwera Nginx (na porcie 80) "ngrok http 80"
		12.5.1 W tym momencie możliwe że wywali błąd "ERR_NGROK_121" ("Your ngrok-agent version "2.3.41" is too old. [...]"). W takim przypadku należy wykonać "ngrok update"
		12.5.2 Możliwe jest także ustawienie podstawowego hasła: "ngrok http 80 --basic-auth "login:haslo""
		12.5.3 Należy pamiętać, że każde uruchomienie tunelowania generuje nowy link.
		12.5.4 Możliwe jest także darmowe wygenerowanie stałego linku
			12.5.4.1 Na stronie głównej https://dashboard.ngrok.com/domains, po lewej stronie panel
			12.5.4.2 Cloud Edge -> domains
			12.5.4.3 New Domain (niebieski przycisk po prawej stronie)
			12.5.4.4 Wygenerowana zostanie stała globalna domena. Niestety w darmowym planie nie można jej edytować ani nazwać dowolnie, jednak jest to absolutnie najłatwiejsze rozwiązanie problemu losowych linków.
			12.5.4.5 Po wygenerowaniu po prawej stronie jest przycisk z ikoną terminala, po jej kliknięciu pojawia się kopiowalny link z url, do którego można dodać basic-auth (12.5.2) stąd przykładowo powstaje pełna komenda: "ngrok http --url=profound-warthog-model.ngrok-free.app 80 --basic-auth "cti:PolitechnikaLodzkaCTI""
	12.6 By uruchomić ngrok w tle wystarczy dodać "> /dev/null &" na koniec przygotowanej komendy
	12.7 (Opcjonalnie, rekomendowane) Automatyczne uruchamianie komendy przy starcie systemu:
		12.7.1 Będąc w katalogu APCUPS: "sudo mv ./ngrok_starter.service /etc/systemd/system/ 
		12.7.2 "systemctl enable ngrok_starter.service"
		12.7.3 Jeżeli ngrok nie pracuje obecnie można także uruchomić go w ten sposób: "systemctl start ngrok_starter.service"
	12.8 (Opcjonalnie) Jest także możliwe zapisanie stałych ustawień tunelowania do pliku konfguracyjnego (lokalizacja podana zostaje po wpisaniu authtokenu, zazwyczaj jest to "/root/.ngrok2/ngrok.yml")
14. "Stałe" IP (Opcjonalnie) Jako, że ngrok pozwala na więcej, ustawienie "stałego" ip jest mniej ważne, ale jeżeli jest wymagane to też zostanie zawarte w instrukcji:
	13.1 "nano /etc/network/interfaces"
	13.2 "
		iface eth0 inet static
		address 192.168.1.100        # Your desired static IP address
		netmask 255.255.255.0        # Your subnet mask
		gateway 192.168.1.1          # Your gateway (router) IP address
		dns-nameservers 8.8.8.8      # DNS server(s) - You can add multiple servers
		"
	13.3 "sudo systemctl restart networking"
	13.4 Alternatywnie za pomocą dwóch komend nmcli: "sudo nmcli con mod "Your Connection Name" ipv4.addresses "192.168.1.100/24" ipv4.gateway "192.168.1.1" ipv4.dns "8.8.8.8" ipv4.method manual; sudo systemctl restart NetworkManager"


X. Mało ważne
	X.1 Podstawowa strefa czasowa tego systemu operacyjnego to Europe/London
		X.1.1 Można ją zmienić za pomocą komendy "sudo timedatectl set-timezone Europe/Warsaw"
		X.1.2 Weryfikacja "date"
		X.1.3 Status APC UPS zostanie zaktualizowany z nową strefą czasową po restarcie systemu
	X.2 Stworzyłem także "skrypt instalacyjny", pozwoli on skrócić większość manualnych kroków (przenoszenie plików, nadawanie uprawnień itd.). ALE NIE BYŁ ON TESTOWANY! Należy także pamiętać by wypełnić ścieżkę jednej zmiennej (na samej górze "APCUPS_location", domyślnie jest ustawiona jako "/home/cti/APCUPS").
	X.3 Niestety instrukcja wydłużyła się do rozmiarów absurdalnych i samo ustawienie wszystkiego zajmie parę godzin (z czego większość czasu to czekanie na zakończenie apt update apt upgrade), to skrypt mimo tego, że nie był testowany, to warto spróbować go uruchomić. 
	X.4 Większość danych podawanych na stronie jest zupełnie zbędna, wiec by zredukować ich ilość i zostawić jedynie parametry ważne, wystarczy kolejno komentować linijki w pliku json_script.sh, który został skonstruowany w sposób to ułatwiający. Jedynie należy zwrócić uwagę, by nie usunąć BEGIN, END oraz w przypadku usuwania "END APC" należy z ostatniego elementu usunąć przecinek (jeżeli on zostanie, JSON nie będzie poprawnie sformatowany i nie zostanie pokazany na stronie).
	X.5 Rekomendowane jest pracowanie cały czas na koncie superużytkownika i na wartościach domyślnych - w ten sposób nie będzie możliwe popełnienie błędu.
	X.6 Możliwe że instrukcja zawiera nieścisłości lub błędy uniemożliwiające poprawną konfigurację projektu, w tym przypadku proszę o kontakt mailowy.
	X.7 Ngrok jak i nginx czasami po prostu nie działają. Nie mam pojęcia dlaczego tak jest i rozwiązanie tego problemu zapewne jest niezwykle skomplikowane, więc jeżeli którekolwiek z jakiegokolwiek powodu się zawiesi, "reboot" zazwyczaj rozwiązuje wszystkie problemy.
	X.8 Najlepiej nie wyciągać kabla podczas pracy raspberry, tylko wykonać komendę "shutdown 0" lub "shutdown now". Wyciągnięcie kabla raz spowodowało uszkodzenie systemu!
