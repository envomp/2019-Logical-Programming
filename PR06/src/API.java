
import org.jpl7.Atom;
import org.jpl7.Query;
import org.jpl7.Term;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.ProtocolException;
import java.net.URL;
import java.net.http.HttpClient;
import java.net.http.HttpHeaders;
import java.util.ArrayList;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class API {

    private final static String regex = "\"AirportCode\":\"(\\w+)\"";

    public static void main(String[] args) throws IOException {

//        URL url = new URL("https://api.lufthansa.com/v1/mds-references/airports/?limit=80&offset=0&LHoperated=0");
//        HttpURLConnection con = (HttpURLConnection) url.openConnection();
//        con.setRequestMethod("GET");
//        con.setRequestProperty("Accept", "application/json");
//        con.setRequestProperty("Authorization", "Bearer ugaxfysn4sb99c3ajec7exmy");
//        con.setRequestProperty("X-Originating-IP", "193.40.250.231");
//
//        BufferedReader in = new BufferedReader(new InputStreamReader(con.getInputStream()));
//        String inputLine;
//        ArrayList<String> airports = new ArrayList<>();
//        while ((inputLine = in.readLine()) != null) {
//            Pattern pattern = Pattern.compile(regex, Pattern.MULTILINE);
//            Matcher matcher = pattern.matcher(inputLine);
//
//            while (matcher.find()) {
//                for (int i = 1; i <= matcher.groupCount(); i++) {
//                    airports.add(matcher.group(i));
//                }
//            }
//        }
//        in.close();
//
//        System.out.println(airports);

	    Query q3 =
			    new Query(
					    "lyhim_reis",
					    new Term[] {new Atom("tallinn") ,new Atom("berlin")}
			    );
	    System.out.println(
			    "lyhim_reis " +
					    ( q3.hasSolution() ? "provable" : "not provable" )
	    );

    }
}
