
import org.jpl7.Atom;
import org.jpl7.Query;
import org.jpl7.Term;
import org.jpl7.Variable;

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
import java.util.HashMap;
import java.util.Hashtable;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class API {

    private final static String regex = "\"AirportCode\":\"(\\w+)\"";

    public static void main(String[] args) throws IOException {

        URL url = new URL("https://api.lufthansa.com/v1/operations/schedules/FRA/TLL/2019-10-16?directFlights=0");
        HttpURLConnection con = (HttpURLConnection) url.openConnection();
        con.setRequestProperty("Accept", "application/json");
		con.setRequestProperty("Authorization", "Bearer 94kenctfkzy2xhbd83jpzr2c");
		con.setRequestProperty("X-Originating-IP", "193.40.250.231");
		con.setRequestMethod("GET");

	    System.out.println(con.getResponseCode());
	    BufferedReader in = new BufferedReader(new InputStreamReader(con.getInputStream()));
	    String inputLine;
	    ArrayList<String> airports = new ArrayList<>();
        while ((inputLine = in.readLine()) != null) {
	        System.out.println(inputLine);
            Pattern pattern = Pattern.compile(regex, Pattern.MULTILINE);
            Matcher matcher = pattern.matcher(inputLine);

            while (matcher.find()) {
                for (int i = 1; i <= matcher.groupCount(); i++) {
                    airports.add(matcher.group(i));
                }
            }
        }
        in.close();

        System.out.println(airports);

//		do_query();
	}

	private static void do_query() {
		String start = "tallinn";
		String end = "berlin";

		String path = "Path";
		String time = "Time";

		Variable Time = new Variable();
		Variable Path = new Variable();

		Query setup = new Query("consult('PR06/src/prax06.pl')");

		System.out.println("consult " + setup.hasSolution());

		Query query_cheapest = new Query(String.format("odavaim_reis(%s, %s, %s, %s).", start, end, path, time));

		Map<String, Term> cheapest = query_cheapest.oneSolution();

		System.out.println(String.format("\n?- odavaim_reis(%s, %s, %s, %s).", start, end, path, time));
		System.out.println("Path = " + cheapest.get(path));
		System.out.println("Time = " + cheapest.get(time));


		System.out.println(String.format("\n\n?- lyhim_reisS(%s, %s, %s, %s).", start, end, path, time));
		Query query_shortest = new Query(String.format("lyhim_reis(%s, %s, %s, %s).", start, end, path, time));

		Map<String, Term> shortest = query_shortest.oneSolution();

		System.out.println("Path = " + shortest.get(path));
		System.out.println("Time = " + shortest.get(time));
	}
}
