package ch.unibas.dmi.dbis.fds._2pc;


import javax.sql.XADataSource;
import javax.transaction.xa.XAException;
import javax.transaction.xa.XAResource;
import java.sql.*;
import java.util.Scanner;


/**
 * Check the XA stuff here --> https://docs.oracle.com/cd/B14117_01/java.101/b10979/xadistra.htm
 *
 * @author Alexander Stiemer (alexander.stiemer at unibas.ch)
 */
public class OracleXaBank extends AbstractOracleXaBank {


    public OracleXaBank(final String BIC, final String jdbcConnectionString, final String dbmsUsername, final String dbmsPassword) throws SQLException {
        super(BIC, jdbcConnectionString, dbmsUsername, dbmsPassword);
    }


    @Override
    public float getBalance(final String iban) throws SQLException {
        float balance = Float.NaN;
        //
        String url = "jdbc:oracle:LinkToBank:p5.dmi.unibas.ch:1521:xe";
        String user = "fdis_25";
        String password = "MrrBP7r";
        Scanner k = new Scanner(System.in);
        String sql = "SELECT BALANCE FROM Account"+
                "WHERE IBAN=iban";
        Connection conn = null;
        try {
            DriverManager.registerDriver(new oracle.jdbc.OracleDriver());

            conn = DriverManager.getConnection(url, user, password);

            Statement state = conn.createStatement();

            ResultSet n = state.executeQuery(sql);
            while (n.next()) {
                System.out.println("BALANCE:" + n.getInt("balance"));


            }
            conn.close();


        } catch (SQLException e) {
            e.printStackTrace();
        }


        // TODO: your turn ;-)
        //throw new UnsupportedOperationException( "Implement me :-)" );
    }




    @Override
    public void transfer( final AbstractOracleXaBank TO_BANK, final String ibanFrom, final String ibanTo, final float value ) throws XAException {
        //
        float balance1= ibanFrom.getBalance();
        float balance2= ibanTo.getBalance();
        String url = "jdbc:oracle:LinkToBank:p5.dmi.unibas.ch:1521:xe";
        String user = "fdis_25";
        String password = "MrrBP7r";
        Connection conn = null;
        try {
            DriverManager.registerDriver(new oracle.jdbc.OracleDriver());

            conn = DriverManager.getConnection(url, user, password);

            Statement state = conn.prepareCall("{call transfer(?,?,?,?,?)}");
            state.setFloat(1,value);
            state.setString(2,ibanFrom);
            state.setString(3,AbstractOracleXaBank.BIC);
            state.setString(4,ibanTo);
            state.setString(5,AbstractOracleXaBank.BIC);

            System.out.println("Tranfer done successfully");


            conn.close();


        } catch (SQLException e) {
            e.printStackTrace();
        }



        // TODO: your turn ;-)
        //throw new UnsupportedOperationException( "Implement me :-)" );
    }
}
