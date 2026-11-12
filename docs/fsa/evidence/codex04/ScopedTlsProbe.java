import java.io.FileInputStream;
import java.net.URL;
import java.security.KeyStore;
import java.security.MessageDigest;
import java.security.cert.CertificateFactory;
import java.security.cert.X509Certificate;
import java.util.Enumeration;
import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLContext;
import javax.net.ssl.TrustManagerFactory;

// Public-endpoint test only. Normal certificate and hostname verification remain enabled.
// The owner-approved root exists only in this process's in-memory keystore.
public final class ScopedTlsProbe {
    public static void main(String[] args) throws Exception {
        X509Certificate root;
        try (FileInputStream input = new FileInputStream("/data/local/tmp/codex04-avast-public.pem")) {
            root = (X509Certificate) CertificateFactory.getInstance("X.509").generateCertificate(input);
        }
        StringBuilder digest = new StringBuilder();
        for (byte value : MessageDigest.getInstance("SHA-256").digest(root.getEncoded())) {
            digest.append(String.format("%02X", value));
        }
        if (!digest.toString().equals("B699A880ED464C43AF4AD3A430FE0B29820EB7C37B1FA5ABEF68014566914EAC")) {
            throw new SecurityException("Unexpected public root fingerprint");
        }
        KeyStore system = KeyStore.getInstance("AndroidCAStore");
        system.load(null);
        KeyStore scoped = KeyStore.getInstance(KeyStore.getDefaultType());
        scoped.load(null);
        for (Enumeration<String> names = system.aliases(); names.hasMoreElements();) {
            String name = names.nextElement();
            scoped.setCertificateEntry(name, system.getCertificate(name));
        }
        scoped.setCertificateEntry("owner-approved-temporary-root", root);
        TrustManagerFactory factory = TrustManagerFactory.getInstance(TrustManagerFactory.getDefaultAlgorithm());
        factory.init(scoped);
        SSLContext context = SSLContext.getInstance("TLS");
        context.init(null, factory.getTrustManagers(), null);
        for (String host : new String[] {"ankiweb.net", "sync.ankiweb.net"}) {
            HttpsURLConnection connection = (HttpsURLConnection) new URL("https://" + host + "/").openConnection();
            connection.setSSLSocketFactory(context.getSocketFactory());
            connection.setConnectTimeout(15000);
            connection.setReadTimeout(15000);
            connection.setRequestMethod("HEAD");
            try {
                int status = connection.getResponseCode();
                System.out.println(host + " HTTP=" + status + " CERTIFICATE_AND_HOSTNAME_VALIDATED=true");
            } finally {
                connection.disconnect();
            }
        }
        System.exit(0);
    }
}
