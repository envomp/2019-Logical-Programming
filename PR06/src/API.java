
import org.jpl7.Atom;
import org.jpl7.Query;
import org.jpl7.Term;
import org.jpl7.Variable;

import java.io.*;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.ProtocolException;
import java.net.URL;
import java.net.http.HttpClient;
import java.net.http.HttpHeaders;
import java.util.*;
import java.util.concurrent.TimeUnit;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class API {

    final static String regex = "\\{\"Departure\":\\{\"AirportCode\":\"(\\w+)\",\"ScheduledTimeLocal\":\\{\"DateTime\":\"\\d{4}-\\d{2}-\\d{2}T(\\d{2}):(\\d{2})\"\\}}?,(\"Terminal\":\\{\"Name\":\\d\\}},)?\"Arrival\":\\{\"AirportCode\":\"(\\w+)\",\"ScheduledTimeLocal\":\\{\"DateTime\":\"\\d{4}-\\d{2}-\\d{2}T(\\d{2}):(\\d{2})\"\\}}?,(\"Terminal\":\\{\"Name\":\\d\\}},)?\"MarketingCarrier\":\\{\"AirlineID\":\"\\w+\",\"FlightNumber\":(\\d+)\\}";
    final static String[] airportCodes = {"BJS", "BER", "BUE", "CHI", "LON", "MIL", "MOW", "NYC", "PAR", "ROM", "SAO", "STO", "TYO", "WAS"};

    public static void main(String[] args) throws InterruptedException, IOException {

//		do_all_APIs();

        do_query("a", "e");
        do_query("bru", "txl");

    }

    private static void do_all_APIs() throws InterruptedException, IOException {
        HashSet<String> airports = new HashSet<>();
        for (String start : airportCodes) {
            for (String end : airportCodes) {
                try {
                    do_API(airports, start, end);
                } catch (IOException e) {
                    e.printStackTrace();
                }
                System.out.println(start);
                System.out.println(end);

                TimeUnit.SECONDS.sleep(1);

            }
        }

        BufferedWriter writer = new BufferedWriter(new FileWriter("src/data.pl"));
        for (String rule : airports) {
            writer.write(rule);
            writer.newLine();
        }
        writer.close();
    }

    private static void do_API(HashSet<String> airports, String start, String end) throws IOException {
        URL url = new URL(String.format("https://api.lufthansa.com/v1/operations/schedules/%s/%s/2019-10-16?directFlights=0", start, end));
        HttpURLConnection con = (HttpURLConnection) url.openConnection();
        con.setRequestProperty("Accept", "application/json");
        con.setRequestProperty("Authorization", "Bearer 94kenctfkzy2xhbd83jpzr2c");
        con.setRequestProperty("X-Originating-IP", "193.40.250.231");
        con.setRequestMethod("GET");

        System.out.println(con.getResponseCode());
        BufferedReader in = new BufferedReader(new InputStreamReader(con.getInputStream()));
        String inputLine;
        while ((inputLine = in.readLine()) != null) {
            System.out.println(inputLine);
            Pattern pattern = Pattern.compile(regex, Pattern.MULTILINE);
            Matcher matcher = pattern.matcher(inputLine);

            while (matcher.find()) {
                String travelPlan = String.format("lennukiga(%s, %s, %s, time(%d, %d, 0.0), time(%d, %d, 0.0)).", matcher.group(1).toLowerCase(), matcher.group(5).toLowerCase(), matcher.group(9), Integer.parseInt(matcher.group(2)), Integer.parseInt(matcher.group(3)), Integer.parseInt(matcher.group(6)), Integer.parseInt(matcher.group(7)));
                airports.add(travelPlan);
                System.out.println(travelPlan);
            }
        }
        in.close();
    }

    private static void do_query(String start, String end) {
        String path = "Path";
        String price = "Price";
        String time = "Time";

        long startTime = System.currentTimeMillis();
        Query setup = new Query("consult('PR06/src/prax06.pl')");

        System.out.println("consult " + setup.hasSolution());

        Query query_cheapest = new Query(String.format("odavaim_reis(%s, %s, %s, %s).", start, end, path, price));

        Map<String, Term> cheapest = query_cheapest.oneSolution();

        System.out.println(String.format("\n?- odavaim_reis(%s, %s, %s, %s).", start, end, path, price));
        System.out.println("Path = " + cheapest.get(path) + ".");
        System.out.println("Price = " + cheapest.get(price) + ".");


        System.out.println(String.format("\n\n?- lyhim_reis(%s, %s, %s, %s, %s).", start, end, path, price, time));
        Query query_shortest = new Query(String.format("lyhim_reis(%s, %s, %s, %s, %s).", start, end, path, price, time));

        Map<String, Term> shortest = query_shortest.oneSolution();

        System.out.println("Path = " + shortest.get(path) + ".");
        System.out.println("Price = " + shortest.get(price) + ".");
        System.out.println("Time = " + shortest.get(time) + ".");
        System.out.println(String.format("\n\nExecution took %s seconds.\n", (double) (System.currentTimeMillis() - startTime) / 1000));
    }
}
