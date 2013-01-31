import org.biojava3.genome.parsers.gff.FeatureList;
import org.biojava3.genome.parsers.gff.FeatureI;
import org.biojava3.genome.parsers.gff.GFF3Reader;

public class FeatureCounter {
  public static void main(String[] args) {
    try {
      FeatureList features = (FeatureList) GFF3Reader.read(args[0]);
      long counter = 0;
      for(FeatureI f : features)
        counter++;
      System.out.println("There are " + counter + " features in the file.");
    } catch (java.io.IOException e) {
    }
  }
}

