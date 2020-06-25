public class EnderecoServiceTO {

    public class BuscaCepTO {
		public String cep {get;set;}
		public String logradouro {get;set;}
        public String complemento {get;set;}
        public String bairro {get;set;}
        public String localidade {get;set;}
        public String uf {get;set;}
        public String unidade {get;set;}
        public String ibge {get;set;}
        public String gia {get;set;}
    }
    
    public class GeocodeTO {
        public List<Result> results { get; set; }
        public String status { get; set; }
    }

    public class Result {
        public List<AddressComponent> addressComponents { get; set; }
        public String formattedAddress { get; set; }
        public Geometry geometry { get; set; }
        public String placeId { get; set; }
        public PlusCode plusCode { get; set; }
        public List<String> types { get; set; }
    }

    public class AddressComponent {
        public String longName { get; set; }
        public String shortName { get; set; }
        public List<String> types { get; set; }
    }

    public class Geometry {
        public Location location { get; set; }
        public String locationType { get; set; }
        public Viewport viewport { get; set; }
    }

    public class PlusCode {
        public String compoundCode { get; set; }
        public String globalCode { get; set; }
    }

    public class Location {
        public Double lat { get; set; }
        public Double lng { get; set; }
    }
    
    public class Viewport {
        public Northeast northeast { get; set; }
        public Southwest southwest { get; set; }
    }

    public class Northeast {
        public Double lat { get; set; }
        public Double lng { get; set; }
    }

    public class Southwest {
        public Double lat { get; set; }
        public Double lng { get; set; }
    }
}
