package ch.unibas.dmi.dbis.fds._2pc;


import javax.sql.XADataSource;
import javax.transaction.xa.XAException;
import javax.transaction.xa.XAResource;
import java.sql.SQLException;


/**
 * Check the XA stuff here --> https://docs.oracle.com/cd/B14117_01/java.101/b10979/xadistra.htm
 *
 * @author Alexander Stiemer (alexander.stiemer at unibas.ch)
 */
public class OracleXaBank extends AbstractOracleXaBank {


    public OracleXaBank( final String BIC, final String jdbcConnectionString, final String dbmsUsername, final String dbmsPassword ) throws SQLException {
        super( BIC, jdbcConnectionString, dbmsUsername, dbmsPassword );
    }


    @Override
    public float getBalance( final String iban ) throws SQLException {
        float balance = Float.NaN;
        //
        balance = this.getBalance(iban);
        return balance;



        // TODO: your turn ;-)
        throw new UnsupportedOperationException( "Implement me :-)" );
    }


    @Override
    public void transfer( final AbstractOracleXaBank TO_BANK, final String ibanFrom, final String ibanTo, final float value ) throws XAException {
        //
        Float balance1= ibanFrom.getBalance();
        Float balance2= ibanTo.getBalance();
        if (ibanFrom.equals(ibanTo)){
            System.println.out("Not possible to transfer to the same account" );
        }else{
            TO_BANK.startTransaction();
            balance1= balance1-value;
            balance2=balance2+value;
            TO_BANK.endTransaction();


        }


        // TODO: your turn ;-)
        throw new UnsupportedOperationException( "Implement me :-)" );
    }
}
