#!/bin/bash
DATE_TODAY="$(date +%Y-%m-%d)"

declare -a WEBSITE_LIST
declare -a KEYWORD_LIST

WEBSITE_LIST=(
"https://www.onvista.de/news/alle-news?tags[]=OnVistaTopNews"
"https://www.finanztrends.info/thema/kategorie-aktien/"
"https://www.h2-view.com/news/all-news/"
"https://www.wallstreet-online.de/nachrichten/aktien-indizes"
"https://www.deraktionaer.de/aktuell/"
"https://www.greencarcongress.com/"
"https://www.finanznachrichten.de/"
"https://www.finanzen.net/news/"
)

KEYWORD_LIST=(
"Tesla"
"Ballard"
"NEL"
"PowerCell"
"Polytec"
)


#for i in "${WEBSITE_LIST[@]}"; do
#	curl -s $i >> /tmp/notification_fetch; 
#	for k in "${KEYWORD_LIST[@]}"; do
#		FETCH_RESULT=$(cat /tmp/notification_fetch | grep -m1 -Eo $k);
#		echo "$i Got fresh news about: $FETCH_RESULT" >> "/home/chris/Desktop/test";
#	done
#done

#for t in "${WEBSITE_LIST[@]}"; do
#	echo "$t" | cut -d'/' -f3 
#done


for i in "${WEBSITE_LIST[@]}"; do
	PRETTY_URL=$(echo "$i" | cut -d'/' -f3);		
	curl -s $i >> /tmp/notification_fetch_"$PRETTY_URL"; 
	case $i in
		"https://www.onvista.de/news/alle-news?tags[]=OnVistaTopNews")
			for k in "${KEYWORD_LIST[@]}"; do
				FETCH_RESULT=$(cat /tmp/notification_fetch_"$PRETTY_URL" | grep "class=\" headline-medium\"" | grep -m1 -oi "$k.*" | cut -d'>' -f6 | cut -d'<' -f1);
				echo "$i Got fresh news about: $FETCH_RESULT $k" >> "/home/chris/Desktop/test";
			done
			;;
		"https://www.finanztrends.info/thema/kategorie-aktien/")
			for k in "${KEYWORD_LIST[@]}"; do
				FETCH_RESULT=$(cat /tmp/notification_fetch_"$PRETTY_URL" | grep -m1 -oi "$k.*" | cut -d'"' -f5);
				echo "$i Got fresh news about: $FETCH_RESULT $k" >> "/home/chris/Desktop/test";
			done
			;;
		"https://www.h2-view.com/news/all-news/")
			for k in "${KEYWORD_LIST[@]}"; do
				FETCH_RESULT=$(cat /tmp/notification_fetch_"$PRETTY_URL" | grep -m1 -o "$k.*" | cut -d'"' -f1);
				echo "$i Got fresh news about: $FETCH_RESULT $k" >> "/home/chris/Desktop/test";
			done
			;;
		"https://www.wallstreet-online.de/nachrichten/aktien-indizes")
			for k in "${KEYWORD_LIST[@]}"; do
				FETCH_RESULT=$(cat /tmp/notification_fetch_"$PRETTY_URL" | grep -m1 -o "$k.*" | cut -d'>' -f2 | cut -d'<' -f1);
				echo "$i Got fresh news about: $FETCH_RESULT $k" >> "/home/chris/Desktop/test";
			done
			;;
		"https://www.deraktionaer.de/aktuell/")
			for k in "${KEYWORD_LIST[@]}"; do
				FETCH_RESULT=$(cat /tmp/notification_fetch_"$PRETTY_URL" | grep -A100 ">Aktuelles<\.*" | grep -m1 -o "$k.*" | cut -d'"' -f1);
				echo "$i Got fresh news about: $FETCH_RESULT $k" >> "/home/chris/Desktop/test";
			done
			;;
		"https://www.finanznachrichten.de/")
			for k in "${KEYWORD_LIST[@]}"; do
				FETCH_RESULT=$(cat /tmp/notification_fetch_"$PRETTY_URL" | grep -A100 -m1 -i ">Aktuelle News.*" | grep -m1 -o "$k.*" | cut -d'"' -f1);
				echo "$i Got fresh news about: $FETCH_RESULT $k" >> "/home/chris/Desktop/test";
			done
			;;
		"https://www.finanzen.net/news/")
			for k in "${KEYWORD_LIST[@]}"; do
				FETCH_RESULT=$(cat /tmp/notification_fetch_"$PRETTY_URL" | grep -ai "Aktuelle\ Nachrichten.*" | grep -m1 -o "$k.*" | cut -d'>' -f2 | cut -d'<' -f1);
				echo "$i Got fresh news about: $FETCH_RESULT $k" >> "/home/chris/Desktop/test";
			done
			;;
		"https://www.greencarcongress.com/")
			for k in "${KEYWORD_LIST[@]}"; do
				FETCH_RESULT=$(cat /tmp/notification_fetch_"$PRETTY_URL" | grep -m1 -oi "$k.*" | cut -d'>' -f2 | cut -d'<' -f1);
				echo "$i Got fresh news about: $FETCH_RESULT $k" >> "/home/chris/Desktop/test";
			done
			;;
	esac
done


rm -rf /tmp/notification_fetch_*
