import org.biojava3.genome.parsers.gff.FeatureList;
import org.biojava3.genome.parsers.gff.GFF3Reader;

public class FeatureCounter {
  public static void main(String[] args) {
    try {
      FeatureList features = (FeatureList) GFF3Reader.read(args[0]);
      System.out.println("There are " + features.size() + " features in the file.");
    } catch (java.io.IOException e) {
    }
  }
}

